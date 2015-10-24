---
---

subjects = [
	"Game Development"
	"Interactive Fiction"
	"Programming"
	"3D Modeling"
	"Music"
	"Graphic Design"
	"Personality"]

print = (s) -> document.write(s)

println = (s) -> document.write(s+"<br><br>")

choose = (list) -> list[Math.floor(Math.random()*list.length)]

shuffle = (list) ->
	if (list==null || list==undefined || !list.constructor==Array)
		return new Array
	[i, temp, rand] = [list.length,0,0]
	while (0!=i)
		rand = Math.floor(Math.random()*i)
		i--
		[list[i],list[rand]] = [list[rand],list[i]]
	return list

header = (s,n=1) -> "<h#{n}>#{s}</h#{n}>"

intro =
	greetings: [
		"Hi. My name is Ben Scott. I am pictured above, next to a warning sign that may or may not have been put up because of me. When I'm not disrupting research, I'm a student at Carnegie Mellon University."
		"Hi. Oops, that's the wrong picture. Oh well. It's a great picture, if it was there you'd see that it's of me pretending to be Paul McCartney walking across the famous Abbey Road."]

	interests: [
		"3D modeling"
		"game development"
		"David Bowie"
		"things made of titanium"
		"playing instruments that have strings"
		"programming in CoffeeScript / C#"
		"architecture"
		"snowboarding & windsurfing"
		"pen-and-ink drawings"
		"graphic design"
		"digital sculpture"]

	projects: [
		"3D renderings"
		"open-source repositories"
		"ongoing game development projects"
		"a blog"
		"poorly-recorded clips of me playing music"]

	interest_lister: -> interest_lister(@interests)

	lister: (list) ->
		s = ""
		for elem in shuffle(list)
			s+="#{elem}, "
		return s

	print: -> return "#{choose(@greetings)} I like #{@lister(@interests)} and rocket science.<br>On this site, you can find #{@lister(@projects)} and all sorts of other nonsense!"

about = ->
	entry = document.getElementsByClassName("entry")[0]
	print(header("About"))
	println(intro.print())

about()


