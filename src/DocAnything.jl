module DocAnything
using Toolips
using ToolipsSession
using ToolipsDefaults
using ToolipsMarkdown
# welcome to your new toolips project!
global LOADED = nothing

function docstring_expander(c::Connection, name::String, docstr::String)
    mainexpander = div("expander$name", expanded = false)
    style!(mainexpander, "background-color" => "blue", "border-radius" => 5px,
    "cursor" => "pointer")
    labela = a("label$name", text = name * " v")
    style!(labela, "color" => "white", "font-weight" => "bold",
    "font-size" => 14pt, "cursor" => "pointer")
    push!(mainexpander, labela)
    lowerexpander = div("lowexpander$name")
    push!(lowerexpander, tmd("$name", docstr))
    style!(lowerexpander, "height" => 0percent, "transition" => 1seconds,
    "opacity" => 0percent, "background-color" => "white")
    on(c, mainexpander, "click") do cm::ComponentModifier
        if cm[mainexpander]["expanded"] == "false"
            style!(cm, lowerexpander, "height" => 50percent,
            "opacity" => 100percent, "overflow" => "scroll")
            cm[mainexpander] = "expanded" => "true"
            return
        end
        style!(cm, lowerexpander, "height" => 0percent, "opacity" => 0percent)
        cm[mainexpander] = "expanded" => "false"
    end
    maincontainer = div("maincont")
    push!(maincontainer, mainexpander, lowerexpander)
    maincontainer::Component{:div}
end

"""
home(c::Connection) -> _
--------------------
The home function is served as a route inside of your server by default. To
    change this, view the start method below.
"""
function home(c::Connection)
    write!(c, ToolipsDefaults.sheet("mainsheet"))
    if isnothing(LOADED)
        write!(c, "please load some docs using `load_doc!(::Module)`")
        return
    end
    mainbod::Component{:body} = body("mainbod")
    docbox::Component{:div} = div("docbox")
    searchbar::Component{:div} = ToolipsDefaults.textdiv("searcher", text = "")
    style!(searchbar, "top" => 0px, "position" => "sticky")
    on(c, searchbar, "keyup") do cm::ComponentModifier
        newdocboxchil = Vector{Servable}()
        srchtxt = cm[searchbar]["text"]
        for docuble in names(LOADED, all = true)
            try
                if contains(string(docuble), srchtxt)
                    d = getfield(LOADED, docuble)
                    exp = Meta.parse("@doc($LOADED.$docuble)")
                    dox = eval(exp)
                    exp = docstring_expander(c, string(docuble),
                    string(dox))
                    push!(newdocboxchil, exp)
                end
            catch

            end
        end
        set_children!(cm, docbox, newdocboxchil)
    end
    style!(searchbar, "background-color" => "lightblue", "font-weight" => "bold")
    style!(docbox, "padding" => 20px, "background-color" => "darkgray")
    for docuble in names(LOADED, all = true)
        try
            if contains(string(docuble), "")
                d = getfield(LOADED, docuble)
                exp = Meta.parse("@doc($LOADED.$docuble)")
                dox = eval(exp)
                exp = docstring_expander(c, string(docuble),
                string(dox))
                push!(docbox, exp)
            end
        catch

        end
    end
    mod_doc = tmd("mainmod", string(@doc(LOADED)))
    headn = h("mainheader", 1, text = string(LOADED), align = "center")
    push!(mainbod, searchbar, headn, mod_doc, docbox)
    write!(c, mainbod)
end

fourofour = route("404") do c
    write!(c, p("404message", text = "404, not found!"))
end

routes = [route("/", home), fourofour]
extensions = Vector{ServerExtension}([Logger(), Session()])
"""
start(IP::String, PORT::Integer, ) -> ::ToolipsServer
--------------------
The start function starts the WebServer.
"""
function start(IP::String = "127.0.0.1", PORT::Integer = 8000)
     ws = WebServer(IP, PORT, routes = routes, extensions = extensions)
     ws.start(); ws
end

load_doc!(mod::Module) = global LOADED = mod

export load_doc!
end # - module
