var ObjectExplorer = {
	initialize : function()
	{
	this.sCurrentObject = null;

	var searchBox = document.createElement("DIV");
	searchBox.setAttribute("class", "JOE_SearchWindow");
	searchBox.className = "JOE_SearchWindow";
	searchBox.innerHTML = '<div class="JOE_Left"></div><div class="JOE_Right"></div><div class="JOE_Content"><input type="text" id="JOE_LocationBar" value="window"/><a href="javascript:void(0)" id="JOE_LocationTrigger">EXPLORE</a></div>'
	/*document.body.appendChild(searchBox);
	this.dObjectBar = document.getElementById("JOE_LocationBar");
	this.dObjectBar.onkeyup = ObjectExplorer.objectBar;
	this.dObjectTrigger = document.getElementById("JOE_LocationTrigger");
	this.dObjectTrigger.onclick = ObjectExplorer.objectBar;
	*/
	},
	objectBar : function(e)
	{
	
			if(typeof e.keyCode == "undefined" || e.keyCode == 13) 
			{
				if(ObjectExplorer.dObjectBar.value == "") { alert("Please fill in object name"); return false; }
				var e = e || window.event;
				ObjectExplorer.sCurrentObject = ObjectExplorer.dObjectBar.value;
				ObjectExplorer.search(ObjectExplorer.dObjectBar.value, 'full');
				ObjectExplorer.dObjectBar.value = "";
			}
	},
	search : function(str, bResult)
	{

				try{
					return this.explore(eval(str), bResult);
					}
				catch(e)
					{
					return ("There is no such object or object does not support this application. ;(");
					}
	},
	explore : function(obj, bResult)
	{
		var aOutput = new Array();
		if(this.sCurrentObject == null) this.sCurrentObject = this.getObjectName(obj);
		var sObjectName = this.sCurrentObject;
		var type = typeof obj;
		if(type == "object" && obj.constructor == Array) type = "array";
		
		for(var property in obj)
			{
				var oProp = new Object();
				oProp.name = property;
				oProp.object = obj[property];
				oProp.type = typeof(obj[property]);
				if(sObjectName != "window" && sObjectName != "document")
				{
					if(oProp.type == "object" && obj[property].style) oProp.type = "DOMobject";
					if(oProp.type == "object" && typeof obj[property].length == "number") oProp.type = "array";
				}
				if(oProp.type == "object" && oProp.type != null && oProp.type != "function") oProp.value = sObjectName +'.' + property;
				else if(oProp.type != "function") oProp.value = obj[property];
				else if(oProp.type = "function"){
						oProp.value = this.escape(obj[property].toString());	
						
						if(oProp.value.indexOf("function () {\n}") > -1) { oProp.value = sObjectName +'.' + property + "()"; oProp.type = "object";}
						else if(oProp.value.indexOf("[native code]") > - 1) {	
								oProp.type = "nativeFunction";
								oProp.value = "[native code]"
							}
					}
				 oProp.reference = sObjectName + "." + oProp.name;
				aOutput.push(oProp);
			}
		this.sCurrentObject = null;		
		switch(bResult)
			{
			case "full":
				return this.drawOutput(aOutput,sObjectName, bResult);
				break;
			default:
				return aOutput;
				break;
			}
	},
	drawOutput : function(aOutput, sObjectName, bResult)	
	{
		var view = document.getElementById("ObjectExplorerOutput");
		var html;
		if(view == null)
		{
			view = document.createElement("DIV");
			view.setAttribute("id", "ObjectExplorerOutput");
			view.setAttribute("class", "ObjectExplorer");
			view.className = "ObjectExplorer";
			
			document.body.appendChild(view);
		}
		
		html = "<table><caption><a href=\"#\" class=\"closeview\" onclick=\"ObjectExplorer.close()\">CLOSE</a>Object location: <span class=\"current\">" + this.drawLocationLinks(sObjectName) + "</span></caption>";
		html +=  "<thead><tr><th>name</th><th>typeof</th><th>contents</th><th>Reference</th><th>Tools</th></tr></thead><tbody>";
		var nLength = aOutput.length;
		for(var i=0; i< nLength; i++)
			{
			 html += '<tr class="'+ aOutput[i].type +'"><td>'
			 html += aOutput[i].name;
			 html += "</td><td>";
			 html += aOutput[i].type;
			 html += "</td><td>";
			 html += this.drawOutputValue(aOutput[i])
			 html += "</td><td>";
			 html += aOutput[i].reference;
			 html += "</td><td>";
			 html += this.drawOutputTools(aOutput[i]);
			 html += "</td></tr>";
			}
		html += "</table>";
		
		view.innerHTML = html;
	},
	drawOutputValue : function(oProp)
	{
		var html = "";
		switch(oProp.type)
			{
			case "object":
				 html += '<a href="javascript:void(0)" onclick="ObjectExplorer.explore(' + oProp.reference + ', \'full\')">'
				 html += oProp.value;
	 			 html += "</a>";
			 	break;
			case "DOMobject":
				html += oProp.object.tagName + ' [<a href="javascript:void(0)" onclick="ObjectExplorer.drawOutputSource(this)">view source</a>]';
				html += '<pre class="functionSource">&lt;' + oProp.object.tagName;
					for(var i=0; i< oProp.object.attributes.length; i++)
					{
						html += "\t" +oProp.object.attributes[i].name + '="' + oProp.object.attributes[i].value + '"\n';
					}
				html += "&gt;" + this.escape(oProp.object.innerHTML) +"&lt;/" + oProp.object.tagName + '&gt;</pre>';
			 	break;
			case "array":
				 html += '<a href="javascript:void(0)" onclick="ObjectExplorer.explore(' + oProp.reference + ', \'full\')">'
				 html += oProp.value;
	 			 html += "</a>";
			 	break;
			case "function":
				html += '[<a href="javascript:void(0)" onclick="ObjectExplorer.drawOutputSource(this)">view source</a>]';
				html += '<pre class="functionSource">' + oProp.value + '</pre>';
				break;
			 default:
				 html += oProp.value;
			 	break;
			}
		return html;
	},
	drawOutputTools : function(oProp)
	{
		var html = "";
		if(oProp.type != "nativeFunction") html += '[<a href="javascript:void(0)" onclick="ObjectExplorer.edit(\'' + oProp.reference +'\', \''+oProp.type +'\', \'full\')">edit</a>]';
		if(oProp.type == "function") html += '[<a href="javascript:void(0)" onclick="ObjectExplorer.run('+ oProp.reference +')">run</a>]';
//		if(oProp.type == "function") html += '<a href="javascript:void(0)" onclick="'+ oProp.reference +'(prompt(\'Params:\'))">[run]</a>';

		return html;
	},
	drawOutputSource : function(e)
	{
			if(e.nextSibling.nextSibling.style.display != "block") e.nextSibling.nextSibling.style.display = "block";
			else e.nextSibling.nextSibling.style.display = "none";
	},
	drawLocationLinks : function(sObjectName)
	{
		aObjects = sObjectName.split(".")
		var links = "";
		for(var i=0; i < aObjects.length; i++)
			{
				if(i>0) links += ".";
				var ref = "";
				for(var k=0; k<i; k++)
				{
					ref += aObjects[k] + ".";
				}
				links += '<a href="javascript:void(0)" onclick="ObjectExplorer.explore(' + ref + aObjects[i] + ', \'full\')">' + aObjects[i] + '</a>'
			}
		return links;
	},
	getObjectName : function(obj)
	{
		var thisCaller = this.getObjectName.caller;
		while ((thisCaller)&&(thisCaller.caller)) {
			thisCaller = thisCaller.caller;
		}
		if (thisCaller) {
			var f = thisCaller.toString();
			var o = f.substr(f.lastIndexOf("(")+1);
			o = o.substr(0, o.lastIndexOf(","));

			if(o.indexOf("\"") > -1) o = o.substr(1, o.length-2);
			if(o.indexOf("\'") > -1) o = o.substr(1, o.length-2);

			return o;
		}else{
			return 'undefined';
		}
	},
	edit : function(obj, sType, bResult)
	{
		var x = prompt("New value:");
		switch(sType)
		{
			case "DOMobject":
				eval(obj).innerHTML = x;
			break;
			case "number":
				x = parseFloat(x);
				eval(obj + "=" + x);
			break;
			default:
				eval(obj + "=" + x);
			break;
		}
		
		this.sCurrentObject = obj.substr(0, obj.lastIndexOf("."));
		if(this.sCurrentObject == "") this.sCurrentObject = "window";
		this.search(this.sCurrentObject, bResult);
	},
	run : function(obj)
	{
		var params = prompt("Params:");
		obj(eval(params));
		
	},
	escape : function(str)
	{
	    var div = document.createElement('div');
	    var text = document.createTextNode(str);
	    div.appendChild(text);
	    return div.innerHTML;
	},
	addEvent : function(oElement, sEventName, fFunction) 
	{ 
		if(oElement.addEventListener) { 
			oElement.addEventListener( sEventName, fFunction, false);
		}else if (oElement.attachEvent){ 
			oElement.attachEvent("on" +  sEventName, fFunction);
		}
	},
	close : function()
	{
		var view = document.getElementById("ObjectExplorerOutput");
		if(view) view.parentNode.removeChild(view);
	}
}

ObjectExplorer.initialize();