import UIKit

var str = "Hello, playground"
import JavaScriptCore
var jsContext: JSContext!
jsContext = JSContext()
jsContext.exceptionHandler = { context, exception in print( exception!.toString() ?? "default")}

if let jsource = Bundle.main.path(forResource: "main", ofType: "js") {
    do {
        let jsSourceContents = try String(contentsOfFile: jsource)
        //print( jsSourceContents )
        jsContext.evaluateScript(jsSourceContents)
    } catch {
        print( error.localizedDescription )
    }
}
var orgContents: String?
if let orgsource = Bundle.main.path(forResource: "README", ofType: "org") {
    do {
        orgContents = try String(contentsOfFile: orgsource)
    } catch {
        print( error.localizedDescription )
    }
}

let parseOrg = jsContext.objectForKeyedSubscript("parse")
//let res = parseOrg?.call(withArguments: ["*TODO\n**subtitle :tagline:\n   contents"])

func showAllTypes( _ children :NSArray, depth: Int ) {
    for child in children {
        if let child = child as? NSDictionary {
            if let typ = child["type"] {
                let indent = String(repeating: " ", count: depth)
                print( "\(indent)\(typ): \(child.allKeys)" )
            }
            if let nextChildren = child["children"] as? NSArray {
                showAllTypes(nextChildren, depth: depth+1)
            }
        }
    }
}

if let contents = orgContents {
    let res = parseOrg?.call(withArguments: [contents])
    
    if let obj = res?.toDictionary() {
        if let chldrn = obj["children"] as? NSArray {
            showAllTypes(chldrn, depth:1)
        }
    }
}
