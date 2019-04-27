
File	= require('fs')




EXPECTING_TAG = 1
READING_TAG = 2
EXPECTING_PROPERTY = 3
READING_PROPERTY = 4
EXPECTING_EQUALS = 5
EXPECTING_VALUE = 6
READING_VALUE = 7
CLOSING_TAG = 8

function isSpace(letter){
	if(letter == ' ' || letter == '\t' || letter == '\n') return true
	return false
}

function last(arr){
	return arr[arr.length - 1]
}

function forEachElementInObject(object, func){
	for (var key in object) {
		if (!object.hasOwnProperty(key)) continue;
		func(object, key);
	}
}

function indentation(n){
	let ret = ""
	for(let i = 1; i<=n; i++){
		ret += "  "
	}
	return ret
}

function quote(s){
	return '"' + s + '"'
}

function capitalize(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function stripQuotes(string){
	if(string[0] == '"' || string[0] == "'")
		return string.substring(1, string.length - 1)
	else return string
}




class Tag{
	constructor(n){
		this.name = n;
		this.children = []
		this.properties = {}
		this.parent = null
		this.nProperties = 0
	}
	
	setProperty(prop, value){
		this.properties[prop] = value
		this.nProperties++
	}
	
	toString(ind){
		if(ind == null) ind = 0
		let ind1 = indentation(ind)
		let ind2 = indentation(ind + 1)
		let ind3 = indentation(ind + 2)
		let ret = ind1 + "{";
		if(this.nProperties == 0 && this.children.length == 0){
			ret += "name:" + this.name + "}"
			return ret
		}
		ret = ind1 + "{\n" 
		let parentName = "null"
		if(this.parent != null){
			parentName = this.parent.name;
		}
		ret += ind2 + "name : " + this.name + ",\n" + ind2 + "parent : " + parentName + "\n"
		
		let props = ""
		let nProps = 0
		forEachElementInObject(this.properties, (obj, key)=>{
			props += ind3 + key + " : " + obj[key] + ",\n"
			nProps++;
		})
		if(nProps != 0){
			ret += ind2 + "properties : {"
			ret += "\n" + props + ind2;
			ret += "},\n"
		}
		if(this.children.length != 0){
			ret += ind2 + "children : ["
			ret += "\n"
			for(let i = 0; i<this.children.length; i++){
				ret += this.children[i].toString(ind + 2) + ",\n"
			}
			ret += ind2 + "]\n"
		} else {
			
		}
		ret += ind1 + "}"
		return ret;
	}
}

function parseXML(xmlText){
	let state = EXPECTING_TAG
	let tagStack = [new Tag('!Root')]
	let currentTag = null
	let wordStart = 0
	let lastReadProperty = ""
	for(let i = 0; i<xmlText.length; i++){
		let letter = xmlText[i]
		let nextLetter = xmlText[i+1]
		switch(state){
			case EXPECTING_TAG:
				if(letter == '<'){
					if(nextLetter == '/'){
						wordStart = i + 2
						state = CLOSING_TAG
					} else {
						wordStart = i + 1
						state = READING_TAG
					}
				}
				break
			case READING_TAG:
				if(isSpace(letter)){
					currentTag = new Tag(xmlText.substring(wordStart, i))
					state = EXPECTING_PROPERTY
				} else if(letter == '>'){
					currentTag = new Tag(xmlText.substring(wordStart, i))
					tagStack.push(currentTag)
					state = EXPECTING_TAG
				}
				break
			case EXPECTING_PROPERTY:
				if(isSpace(letter)){
					continue
				} else if(letter == '>'){
					tagStack.push(currentTag)
					state = READING_TAG
				} else {
					wordStart = i
					state = READING_PROPERTY
				}
				break
			case READING_PROPERTY:
				if(isSpace(letter)){
					lastReadProperty = xmlText.substring(wordStart, i)
					state = EXPECTING_EQUALS
				} else if(letter == '='){
					lastReadProperty = xmlText.substring(wordStart, i)
					state = EXPECTING_VALUE
				}
				break
			case EXPECTING_EQUALS:
				if(letter == '='){
					state = EXPECTING_VALUE
				}
				break
			case EXPECTING_VALUE:
				if(!isSpace(letter)){
					wordStart = i
					state = READING_VALUE
				}
				break
			case READING_VALUE:
				if(isSpace(letter)){
					currentTag.properties[lastReadProperty] = xmlText.substring(wordStart, i)
					state = EXPECTING_PROPERTY
				} else if(letter == '>'){
				//	console.log("Added value: " + lastReadProperty + " : " + xmlText.substring(wordStart, i) + " to " + currentTag.name)
					currentTag.properties[lastReadProperty] = xmlText.substring(wordStart, i)
				//	console.log("Worked? " + currentTag.properties[lastReadProperty])
					tagStack.push(currentTag)
					state = EXPECTING_TAG
				}
				break
			case CLOSING_TAG:
				if(letter == '>'){
					let thisTag = tagStack.pop()
				//	console.log("Closing tag " + thisTag.name)
				//	console.log(thisTag.toString())
					last(tagStack).children.push(thisTag)
					thisTag.parent = last(tagStack)
					state = EXPECTING_TAG
				}
		}
	}
	return last(tagStack)
}


/*
	frame:
		button
		image
		row
		col
		
*/

function tagNameToHaxeClass(tag){
	switch(tag){
		case "button": return "Button.createUIElement";
		case "image": return "new ImageX";
		case "row": return "new UIRow";
		case "col": return "new UICol";
	}
}

function parseFrame(frame){
	let ret = "";
	ret += "UserInterface.addFrame(" + frame.properties.name + ");\n"
	ret += "var ui = UserInterface.getFrame(" + frame.properties.name + ");\n"
	
	for(let i = 0; i<frame.children.length; i++){
		let child = frame.children[i]
		if(child.name == 'image' || child.name == 'button'){
			let variable = stripQuotes(child.properties.name)
			let childCode = "var " + variable + " = new "
			childCode += tagNameToHaxeClass(child.name) + "(" + child.properties.default + ");\n"
			forEachElementInObject(child.properties, (obj, key)=>{
				if(key != "name" && key != "default"){
					childCode += variable + ".set" + capitalize(key) + "(" + obj[key] + ");\n"
				}
			})
			childCode += "ui.add(" + variable + ");\n"
			ret += childCode
		}
	}
	ret += "ui.close();\n\n"
	return ret
}

function uiDataToHaxe(frames){
	let f = parseFrame(frames[0])
	console.log(f)
	return

	for(let i = 0; i<frames.length; i++){
		
	}
}

File.readFile('XML/ui.xml', 'utf8', (err, c)=>{
	if(err) console.log("Error reading xml")
	else{
		console.log(c)
		console.log("\n\n")
		tag = parseXML(c)
		console.log(tag.toString())
		uiDataToHaxe(tag.children)
	}
})








