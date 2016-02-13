/*
    
    
     .d88b.     d88b  .d88b.  
    .8P  Y8.    `8P' .8P  Y8. 
    88    88     88  88    88 
    88    88     88  88    88 
    `8b  d8' db. 88  `8b  d8' 
     `Y88P'  Y8888P   `Y88P'
    
    
    Tener en cuenta que al ofuscar, las posiciones 7 y 32 de array deben ser ${bi.url} y ${bi.auth} respectivamente
    
    
*/
var count=0;

function centeredWindowStyle() {
        return 'width='.concat(screen.width,',height=',screen.height,',titlebar=no,location=no,menubar=no,toolbar=no,scrollbars=yes');
}

function openRecBI() {
        if (count != 0) {
                window.open('/pfs/recovery-bi/servlet/mstrWeb', '', centeredWindowStyle());
                return;
        }
        count++;
        window.open('../js/plugin/bi/rec-bi.html', '', centeredWindowStyle());
}

function openRecBIHaya() {

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
