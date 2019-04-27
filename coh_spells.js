
File = require('fs')

function findChar(text, char){
	for(let i = 0; i<text.length; i++){
		if(text[i] == char){
			return i
		}
	}
	return -1
}

function processText(text){
	let ret = ""
	let lines = text.split('\n')
	for(let i = 0; i<lines.length; i++){
		let line = lines[i]
		if(line[0] == '[' || line[0] == '{'){
			let closePos = findChar(line, ']')
			if(closePos == -1){
				closePos = findChar(line, '}')
			}
			ret += '\t' + line + '\n'
		}
	}
	return ret
}

File.readFile("Spells.txt", 'utf8', (err, content)=>{
	if(err) console.log(err)
	else{
		console.log("Got content as: ")
		console.log(content)
		let newFile = processText(content)
		File.writeFile("Spell_Names.txt", newFile, (er, c)=>{
			if(err) console.log("Fuck")
			else console.log("Yeeet!!")
		})
	}
})
