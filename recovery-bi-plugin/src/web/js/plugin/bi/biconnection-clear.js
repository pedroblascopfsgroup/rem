/*
    
    
     .d88b.     d88b  .d88b.  
    .8P  Y8.    `8P' .8P  Y8. 
    88    88     88  88    88 
    88    88     88  88    88 
    `8b  d8' db. 88  `8b  d8' 
     `Y88P'  Y8888P   `Y88P'
    
    
    Tener en cuenta que al ofuscar, las posiciones 1, 2, 3, 4, 5 y 6 del array deben ser ${bi.auth},${bi.url},${bi.u1},${bi.p1},${bi.u2},${bi.p2} respectivamente
    
    
*/

var url1='1111';
var url2='2222';
var u1='3333';
var p1='4444';
var u2='5555';
var p2='6666';

var count=0;
var lCartera="";

function centeredWindowStyle() {
        return 'width='.concat(screen.width,',height=',screen.height,',top=0,left=0,titlebar=no,location=no,menubar=no,toolbar=no,scrollbars=yes');
}

function openRecBI() {
        if (count != 0) {
                window.open(url1, '', centeredWindowStyle());
                return;
        }
        count++;
        window.open('../js/plugin/bi/rec-bi.html', '', centeredWindowStyle());
}

function openRecBIHayaMulti(pCartera) {
	if (lCartera != pCartera) {
		count = 0;
	}
	lCartera = pCartera;
	openRecBIHaya();
}

function openRecBIHaya() {

	var pagina = '../js/plugin/bi/rec-biHaya.html';
	var pagina2 = url1;
	
    if (lCartera == "HAYA" || lCartera == "SAREB") {
    	pagina = '../js/plugin/bi/rec-biHayaSareb.html';
    	pagina2= url1;
    } else if (lCartera == "CAJAMAR" || lCartera == "BCC") {
    	pagina = '../js/plugin/bi/rec-biHayaBcc.html';
    	pagina2= url1;
    }

    if (count != 0) {
        window.open(pagina2, '', centeredWindowStyle());
        return;
    }
    count++;    
    window.open(pagina, '', centeredWindowStyle());

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
	var form = createHiddenAuthForm(url2, u1, p1);
 	document.body.appendChild(form);
 	form.submit();
}

function login2RecBIHaya() {

	var form = createHiddenAuthForm(url2, u1, p1);
 	document.body.appendChild(form);
 	form.submit();

} 

function login2RecBIHayaSareb() {

	var form = createHiddenAuthForm(url2, u1, u1);
 	document.body.appendChild(form);
 	form.submit();

} 

function login2RecBIHayaBcc() {

	var form = createHiddenAuthForm(url2, u2, u2);
 	document.body.appendChild(form);
 	form.submit();

} 
