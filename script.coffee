window.onload = ()->

	btn = document.querySelector('.submit-btn')
	settings = document.querySelector('.settings-form')
	selects = settings.querySelectorAll('select')

	getCurrentPropValue = (elem, propName)->
		if elem.currentStyle?
			allValues = {
				top: elem.currentStyle.top
				left: elem.currentStyle.left
				width: elem.offsetWidth
				height: elem.offsetHeight
			}
			return parseInt allValues[propName], 10
		if window.getComputedStyle?
			return parseInt window.getComputedStyle(elem, null).getPropertyValue(propName), 10
		0

	processAnimation = (elem, propName, propValue, animTime = 5)->
		if not elem.customTimer?
			elem.customTimer = {}
		if elem.customTimer[propName]?
			clearInterval elem.customTimer[propName]
		currValue = getCurrentPropValue elem, propName
		diff = Math.abs(currValue - propValue)
		frameDuration = Math.ceil(animTime * 1000 / diff)
		directionFactor = if currValue < propValue then 1 else -1
		frame = ()->
			if currValue is propValue
				clearInterval elem.customTimer[propName]
				return
			currValue += directionFactor
			elem.style[propName] = "#{currValue}px"
			return
		elem.customTimer[propName] = setInterval frame, frameDuration
		frame()
		return

	modifyBoxProperty = (target, doAnimate)->
		box = document.querySelector('#box')
		propName = target.getAttribute 'name'
		propValue = parseInt target.value, 10
		if doAnimate
			processAnimation box, propName, propValue
		else
			box.style[propName] = "#{propValue}px"
		return

	generateOptions = (min, max)->
		frag = document.createDocumentFragment()
		out = []
		for index in [min..max]
			option = document.createElement 'option'
			option.value = index
			option.innerHTML = index
			frag.appendChild option
		frag

	for item in selects
		[min, max] = item.dataset.optionRange.split '-'
		item.appendChild generateOptions(min, max)
		modifyBoxProperty item, false

	settings.addEventListener 'change', (ev)->
		if ev.target and ev.target.nodeName.toLowerCase() is 'select'
			modifyBoxProperty ev.target, true
		return

	return
