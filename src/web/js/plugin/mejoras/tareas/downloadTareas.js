Ext.BLANK_IMAGE_URL = '../fwk/ext3.4/resources/images/default/s.gif';
Ext.onReady(function() {
var body = Ext.getBody();
var getParams = document.URL.split("?");
var params;

params = Ext.urlDecode(getParams[getParams.length - 1]) ;
var valorcodigoTipoTarea = params['codigoTipoTarea'];

if(params['codigoTipoTarea'] == null){ 

	params = Ext.urlDecode(getParams[getParams.length - 2]) ;
	params['params'] = getParams[getParams.length-1].split('params=');
	valorcodigoTipoTarea = params['codigoTipoTarea'];

	if(params['codigoTipoTarea'] == null){ 
		params = Ext.urlDecode(getParams[getParams.length - 3]) ;
	}	
}


	var frame = body.createChild({
		tag:'iframe'
		,cls:'x-hidden'
		,id:'iframe'
		,name:'iframe'
	});

	var form = body.createChild({
		tag:'form'
		,cls:'x-hidden'
		,id:'form'
		,action:'../plugin/mejoras/tareas/core.exportTareas.htm'
		,target:'iframe'
		,method: 'post'
		,enctype: 'application/x-www-form-urlencoded'
		,encoding: 'application/x-www-form-urlencoded'
	});

	valorcodigoTipoTarea = params['codigoTipoTarea'];
	if(params['codigoTipoTarea'] == null){ valorcodigoTipoTarea = '';}
	var hiddenItem0 = document.createElement('input');
	Ext.fly(hiddenItem0).set({
		type: 'hidden',
		value: valorcodigoTipoTarea,
		name: 'codigoTipoTarea'
	});
	form.appendChild(hiddenItem0);

	var valordescripcionTarea = escape(params['descripcionTarea']);
	if(params['descripcionTarea'] == null){ valordescripcionTarea = '';}
	var hiddenItem1 = document.createElement('input');
	Ext.fly(hiddenItem1).set({
		type: 'hidden',
		value: valordescripcionTarea,
		name: 'descripcionTarea'
	});
	form.appendChild(hiddenItem1);

	var valorenEspera = params['enEspera'];
	if(params['enEspera'] == null){ valorenEspera = '';}
	var hiddenItem2 = document.createElement('input');
	Ext.fly(hiddenItem2).set({
		type: 'hidden',
		value: valorenEspera,
		name: 'enEspera'
	});
	form.appendChild(hiddenItem2);


	var valoresAlerta = params['esAlerta'];
	if(params['esAlerta'] == null){ valoresAlerta = '';}			
	var hiddenItem3 = document.createElement('input');
	Ext.fly(hiddenItem3).set({
		type: 'hidden',
		value: valoresAlerta,
		name: 'esAlerta'
	});
	form.appendChild(hiddenItem3);

	var valorfechaVencDesdeOperador = params['fechaVencDesdeOperador'];
	if(params['fechaVencDesdeOperador'] == null){valorfechaVencDesdeOperador = '';}			
	var hiddenItem4 = document.createElement('input');
	Ext.fly(hiddenItem4).set({
		type: 'hidden',
		value: valorfechaVencDesdeOperador,
		name: 'fechaVencDesdeOperador'
	});
	form.appendChild(hiddenItem4);
	
	var valorfechaVencimientoDesde = params['fechaVencimientoDesde'];
	if(params['fechaVencimientoDesde'] == null){valorfechaVencimientoDesde = '';}		
	var hiddenItem5 = document.createElement('input');
	Ext.fly(hiddenItem5).set({
		type: 'hidden',
		value: valorfechaVencimientoDesde,
		name: 'fechaVencimientoDesde'
	});
	form.appendChild(hiddenItem5);

	var valorfechaVencimientoHasta = params['fechaVencimientoHasta'];
	if(params['fechaVencimientoHasta'] == null){valorfechaVencimientoHasta = '';}
	var hiddenItem6 = document.createElement('input');
	Ext.fly(hiddenItem6).set({
		type: 'hidden',
		value: valorfechaVencimientoHasta,
		name: 'fechaVencimientoHasta'
	});
	form.appendChild(hiddenItem6);

	var valorfechaVencimientoHastaOperador = params['fechaVencimientoHastaOperador'];
	if(params['fechaVencimientoHastaOperador'] == null){ valorfechaVencimientoHastaOperador = '';}
	var hiddenItem7 = document.createElement('input');
	Ext.fly(hiddenItem7).set({
		type: 'hidden',
		value: valorfechaVencimientoHastaOperador,
		name: 'fechaVencimientoHastaOperador'
	});
	form.appendChild(hiddenItem7);

	var valorlimit = params['limit'];
	if(params['limit'] == null){ valorlimit = '';}
	var hiddenItem8 = document.createElement('input');
	Ext.fly(hiddenItem8).set({
		type: 'hidden',
		value: valorlimit,
		name: 'limit'
	});
	form.appendChild(hiddenItem8);

	var valornombreTarea = escape(params['nombreTarea']);
	if(params['nombreTarea'] == null){ valornombreTarea = '';}
	var hiddenItem9 = document.createElement('input');
	Ext.fly(hiddenItem9).set({
		type: 'hidden',
		value: valornombreTarea,
		name: 'nombreTarea'
	});
	form.appendChild(hiddenItem9);	

	var valorperfilUsuario = params['perfilUsuario'];
	if(params['perfilUsuario'] == null){ valorperfilUsuario = '';}
	var hiddenItem10 = document.createElement('input');
	Ext.fly(hiddenItem10).set({
		type: 'hidden',
		value: valorperfilUsuario,
		name: 'perfilUsuario'
	});
	form.appendChild(hiddenItem10);
	
	var hiddenItem11 = document.createElement('input');
	Ext.fly(hiddenItem11).set({
		type: 'hidden',
		value: 'true',
		name: 'busqueda'
	});
	form.appendChild(hiddenItem11);

    form.dom.submit();
}


);
 // eo function onReady
// eof