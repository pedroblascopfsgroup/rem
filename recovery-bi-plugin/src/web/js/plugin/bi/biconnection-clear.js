var count=0;

function centeredWindowStyle() {
//        var width = 0.9 * screen.width;
//        var height = 0.9 * screen.height;
//        var leftSize = (screen.width - width)/2;
//        var topSize = (screen.height - height)/2;
//        return 'width='.concat(width,',height=',height,',top=',topSize,',left=',leftSize,',titlebar=no,location=no,menubar=no,toolbar=no,scrollbars=yes');
    return 'titlebar=no,location=no,menubar=no,toolbar=no,scrollbars=yes';
}

function openRecBI() {
	
	// TODO: Probar cuando est� en el mismo dominio
	/*var win = new Ext.Window({  
	        id: 'windowBI',  
	        title: 'Recovery BI',  
	        width: 1000,  
	        height: 600,  
	        layout: 'fit',  
	        autoLoad : {  
	            url : '../js/plugin/bi/rec-bi.html',  
	            scripts: true  
	        }  
	});  
	win.show();*/

	// Desconexi�n previa (no es compatible con IE9)
	/*var xmlhttp=new XMLHttpRequest();
        xmlhttp.open("GET","/pfs/recovery-bi/servlet/mstrWeb?evt=3019&src=mstrWeb.3019",false);
        xmlhttp.send();*/

        if (count != 0) {
                window.open('/pfs/recovery-bi/servlet/mstrWeb', '', centeredWindowStyle());
                return;
        }
        count++;
        window.open('../js/plugin/bi/rec-bi.html', '', centeredWindowStyle());
}

function openRecBIHaya() {
	
	// TODO: Probar cuando est� en el mismo dominio
	/*var win = new Ext.Window({  
	        id: 'windowBI',  
	        title: 'Recovery BI',  
	        width: 1000,  
	        height: 600,  
	        layout: 'fit',  
	        autoLoad : {  
	            url : '../js/plugin/bi/rec-bi.html',  
	            scripts: true  
	        }  
	});  
	win.show();*/

	// Desconexi�n previa (no es compatible con IE9)
	/*var xmlhttp=new XMLHttpRequest();
        xmlhttp.open("GET","/pfs/recovery-bi/servlet/mstrWeb?evt=3019&src=mstrWeb.3019",false);
        xmlhttp.send();*/

        if (count != 0) {
                window.open('/pfs/recovery-bi/servlet/mstrWeb', '', centeredWindowStyle());
                return;
        }
        count++;
        window.open('../js/plugin/bi/rec-biHaya.html', '', centeredWindowStyle());
}


function createForm(url) {
	var form = document.createElement('form');
	form.setAttribute('method', 'post');
	form.setAttribute('action', url);
	return form;
}

function createHiddenInput(name, value) {
	var hiddenField = document.createElement('input');
        hiddenField.setAttribute('type', 'hidden');
        hiddenField.setAttribute('name', name);
        hiddenField.setAttribute('value', value);
	return hiddenField;
}

function createHiddenAuthForm(url, user, pass) {
	var form = createForm(url);
        form.appendChild(createHiddenInput('Uid', user));
        form.appendChild(createHiddenInput('Pwd', pass));
	return form;
}


function getParamFromURL(param) {
	var query = window.location.search.substring(1);
	var vars = query.split("&");
	for (var i=0;i<vars.length;i++) {
		var pair = vars[i].split("=");
		if(pair[0] == param){return pair[1];}
	}
	return "";
}


function login2RecBI() {
	var form = createHiddenAuthForm('../../../recovery-bi/servlet/mstrWeb', 'PfYf7lC9kAUY', 'o8gkPlBGLe1yeIOYpPvi');
 	document.body.appendChild(form);
 	form.submit();
}

function login2RecBIHaya() {
	var form = createHiddenAuthForm('../../../recovery-bi/servlet/mstrWeb', 'HaiGasdm6Lq', 'H9cp153TEvkEzT2F1y');
 	document.body.appendChild(form);
 	form.submit();
} 

