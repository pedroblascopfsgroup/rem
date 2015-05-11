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
		,action:'../busquedaTareas/BTAExportTareas.htm'
		,target:'iframe'
		,method: 'post'
		,enctype: 'application/x-www-form-urlencoded'
		,encoding: 'application/x-www-form-urlencoded'
	});
	
	var valornombreTarea = escape(params['nombreTarea']);
	if(params['nombreTarea'] == null){ valornombreTarea = '';}
	var hiddenItem0 = document.createElement('input');
	Ext.fly(hiddenItem0).set({
		type: 'hidden',
		value: valornombreTarea,
		name: 'nombreTarea'
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
	
	var valorambitoTarea = params['ambitoTarea'];
	if(params['ambitoTarea'] == null){ valorambitoTarea = '';}
	var hiddenItem2 = document.createElement('input');
	Ext.fly(hiddenItem2).set({
		type: 'hidden',
		value: valorambitoTarea,
		name: 'ambitoTarea'
	});
	form.appendChild(hiddenItem2);
	
	var valorestadoTarea = params['estadoTarea'];
	if(params['estadoTarea'] == null){ valorestadoTarea = '';}
	var hiddenItem3 = document.createElement('input');
	Ext.fly(hiddenItem3).set({
		type: 'hidden',
		value: valorestadoTarea,
		name: 'estadoTarea'
	});
	form.appendChild(hiddenItem3);
	
	var valorugGestion = params['ugGestion'];
	if(params['ugGestion'] == null){ valorugGestion = '';}
	var hiddenItem4 = document.createElement('input');
	Ext.fly(hiddenItem4).set({
		type: 'hidden',
		value: valorugGestion,
		name: 'ugGestion'
	});
	form.appendChild(hiddenItem4);
	
	valorcodigoTipoTarea = params['codigoTipoTarea'];
	if(params['codigoTipoTarea'] == null){ valorcodigoTipoTarea = '';}
	var hiddenItem5 = document.createElement('input');
	Ext.fly(hiddenItem5).set({
		type: 'hidden',
		value: valorcodigoTipoTarea,
		name: 'codigoTipoTarea'
	});
	form.appendChild(hiddenItem5);
	
	var valorcodigoTipoSubTarea = params['codigoTipoSubTarea'];
	if(params['codigoTipoSubTarea'] == null){ valorcodigoTipoSubTarea = '';}
	var hiddenItem6 = document.createElement('input');
	Ext.fly(hiddenItem6).set({
		type: 'hidden',
		value: valorcodigoTipoSubTarea,
		name: 'codigoTipoSubTarea'
	});
	form.appendChild(hiddenItem6);
	
	var valorfechaVencDesdeOperador = params['fechaVencDesdeOperador'];
	if(params['fechaVencDesdeOperador'] == null){valorfechaVencDesdeOperador = '';}			
	var hiddenItem7 = document.createElement('input');
	Ext.fly(hiddenItem7).set({
		type: 'hidden',
		value: valorfechaVencDesdeOperador,
		name: 'fechaVencDesdeOperador'
	});
	form.appendChild(hiddenItem7);
	
	var valorfechaInicioDesdeOperador = params['fechaInicioDesdeOperador'];
	if(params['fechaInicioDesdeOperador'] == null){valorfechaInicioDesdeOperador = '';}			
	var hiddenItem8 = document.createElement('input');
	Ext.fly(hiddenItem8).set({
		type: 'hidden',
		value: valorfechaInicioDesdeOperador,
		name: 'fechaInicioDesdeOperador'
	});
	form.appendChild(hiddenItem8);
	
	var valorfechaFinDesdeOperador = params['fechaFinDesdeOperador'];
	if(params['fechaFinDesdeOperador'] == null){valorfechaFinDesdeOperador = '';}			
	var hiddenItem9 = document.createElement('input');
	Ext.fly(hiddenItem9).set({
		type: 'hidden',
		value: valorfechaFinDesdeOperador,
		name: 'fechaFinDesdeOperador'
	});
	form.appendChild(hiddenItem9);
	
	var valorfechaVencimientoDesde = params['fechaVencimientoDesde'];
	if(params['fechaVencimientoDesde'] == null){valorfechaVencimientoDesde = '';}		
	var hiddenItem10 = document.createElement('input');
	Ext.fly(hiddenItem10).set({
		type: 'hidden',
		value: valorfechaVencimientoDesde,
		name: 'fechaVencimientoDesde'
	});
	form.appendChild(hiddenItem10);
	
	var valorfechaInicioDesde = params['fechaInicioDesde'];
	if(params['fechaInicioDesde'] == null){valorfechaInicioDesde = '';}			
	var hiddenItem11 = document.createElement('input');
	Ext.fly(hiddenItem11).set({
		type: 'hidden',
		value: valorfechaInicioDesde,
		name: 'fechaInicioDesde'
	});
	form.appendChild(hiddenItem11);
	
	var valorfechaFinDesde = params['fechaFinDesde'];
	if(params['fechaFinDesde'] == null){valorfechaFinDesde = '';}			
	var hiddenItem12 = document.createElement('input');
	Ext.fly(hiddenItem12).set({
		type: 'hidden',
		value: valorfechaFinDesde,
		name: 'fechaFinDesde'
	});
	form.appendChild(hiddenItem12);
	
	var valorfechaVencimientoHastaOperador = params['fechaVencimientoHastaOperador'];
	if(params['fechaVencimientoHastaOperador'] == null){ valorfechaVencimientoHastaOperador = '';}
	var hiddenItem13 = document.createElement('input');
	Ext.fly(hiddenItem13).set({
		type: 'hidden',
		value: valorfechaVencimientoHastaOperador,
		name: 'fechaVencimientoHastaOperador'
	});
	form.appendChild(hiddenItem13);
	
	var valorfechaInicioHastaOperador = params['fechaInicioHastaOperador'];
	if(params['fechaInicioHastaOperador'] == null){ valorfechaInicioHastaOperador = '';}
	var hiddenItem14 = document.createElement('input');
	Ext.fly(hiddenItem14).set({
		type: 'hidden',
		value: valorfechaInicioHastaOperador,
		name: 'fechaInicioHastaOperador'
	});
	form.appendChild(hiddenItem14);
	
	var valorfechaVencimientoHasta = params['fechaVencimientoHasta'];
	if(params['fechaVencimientoHasta'] == null){valorfechaVencimientoHasta = '';}
	var hiddenItem15 = document.createElement('input');
	Ext.fly(hiddenItem15).set({
		type: 'hidden',
		value: valorfechaVencimientoHasta,
		name: 'fechaVencimientoHasta'
	});
	form.appendChild(hiddenItem15);
	
	var valorfechaInicioHasta = params['fechaInicioHasta'];
	if(params['fechaInicioHasta'] == null){valorfechaInicioHasta = '';}
	var hiddenItem16 = document.createElement('input');
	Ext.fly(hiddenItem16).set({
		type: 'hidden',
		value: valorfechaInicioHasta,
		name: 'fechaInicioHasta'
	});
	form.appendChild(hiddenItem16);
	
	var valorfechaFinHasta = params['fechaFinHasta'];
	if(params['fechaFinHasta'] == null){valorfechaFinHasta = '';}
	var hiddenItem17 = document.createElement('input');
	Ext.fly(hiddenItem17).set({
		type: 'hidden',
		value: valorfechaFinHasta,
		name: 'fechaFinHasta'
	});
	form.appendChild(hiddenItem17);
	
	var valorbusquedaUsuario = params['busquedaUsuario'];
	if(params['busquedaUsuario'] == null){valorbusquedaUsuario = '';}
	var hiddenItem18 = document.createElement('input');
	Ext.fly(hiddenItem18).set({
		type: 'hidden',
		value: valorbusquedaUsuario,
		name: 'busquedaUsuario'
	});
	form.appendChild(hiddenItem18);
	
	var valordespacho = params['despacho'];
	if(params['despacho'] == null){valordespacho = '';}
	var hiddenItem19 = document.createElement('input');
	Ext.fly(hiddenItem19).set({
		type: 'hidden',
		value: valordespacho,
		name: 'despacho'
	});
	form.appendChild(hiddenItem19);
	
	var valorgestores = params['gestores'];
	if(params['gestores'] == null){valorgestores = '';}
	var hiddenItem20 = document.createElement('input');
	Ext.fly(hiddenItem20).set({
		type: 'hidden',
		value: valorgestores,
		name: 'gestores'
	});
	form.appendChild(hiddenItem20);
	
	var valortipoGestor = params['tipoGestor'];
	if(params['tipoGestor'] == null){valortipoGestor = '';}
	var hiddenItem21 = document.createElement('input');
	Ext.fly(hiddenItem21).set({
		type: 'hidden',
		value: valortipoGestor,
		name: 'tipoGestor'
	});
	form.appendChild(hiddenItem21);
	
	var valortipoGestorTarea = params['tipoGestorTarea'];
	if(params['tipoGestorTarea'] == null){valortipoGestorTarea = '';}
	var hiddenItem22 = document.createElement('input');
	Ext.fly(hiddenItem22).set({
		type: 'hidden',
		value: valortipoGestorTarea,
		name: 'tipoGestorTarea'
	});
	form.appendChild(hiddenItem22);
	
	var valorperfilesAbuscar = params['perfilesAbuscar'];
	if(params['perfilesAbuscar'] == null){valorperfilesAbuscar = '';}
	var hiddenItem23 = document.createElement('input');
	Ext.fly(hiddenItem23).set({
		type: 'hidden',
		value: valorperfilesAbuscar,
		name: 'perfilesAbuscar'
	});
	form.appendChild(hiddenItem23);
	
	var valornivelEnTarea = params['nivelEnTarea'];
	if(params['nivelEnTarea'] == null){valornivelEnTarea = '';}
	var hiddenItem24 = document.createElement('input');
	Ext.fly(hiddenItem24).set({
		type: 'hidden',
		value: valornivelEnTarea,
		name: 'nivelEnTarea'
	});
	form.appendChild(hiddenItem24);
	
	var valorzonasAbuscar = params['zonasAbuscar'];
	if(params['zonasAbuscar'] == null){valorzonasAbuscar = '';}
	var hiddenItem25 = document.createElement('input');
	Ext.fly(hiddenItem25).set({
		type: 'hidden',
		value: valorzonasAbuscar,
		name: 'zonasAbuscar'
	});
	form.appendChild(hiddenItem25);
	
	var valorparams = params['params'];
	if(params['params'] == null){valorparams = '';}
	var hiddenItem26 = document.createElement('input');
	Ext.fly(hiddenItem26).set({
		type: 'hidden',
		value: valorparams,
		name: 'params'
	});
	form.appendChild(hiddenItem26);
	
	var valorenEspera = params['enEspera'];
	if(params['enEspera'] == null){ valorenEspera = '';}
	var hiddenItem27 = document.createElement('input');
	Ext.fly(hiddenItem27).set({
		type: 'hidden',
		value: valorenEspera,
		name: 'enEspera'
	});
	form.appendChild(hiddenItem27);

	var valoresAlerta = params['esAlerta'];
	if(params['esAlerta'] == null){ valoresAlerta = '';}			
	var hiddenItem28 = document.createElement('input');
	Ext.fly(hiddenItem28).set({
		type: 'hidden',
		value: valoresAlerta,
		name: 'esAlerta'
	});
	form.appendChild(hiddenItem28);	

	var valorlimit = params['limit'];
	if(params['limit'] == null){ valorlimit = '';}
	var hiddenItem29 = document.createElement('input');
	Ext.fly(hiddenItem29).set({
		type: 'hidden',
		value: valorlimit,
		name: 'limit'
	});
	form.appendChild(hiddenItem29);	
	
	var hiddenItem30 = document.createElement('input');
	Ext.fly(hiddenItem30).set({
		type: 'hidden',
		value: 'true',
		name: 'busqueda'
	});
	form.appendChild(hiddenItem30);
	

    form.dom.submit();
}


);
 // eo function onReady
// eof