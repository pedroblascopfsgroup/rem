<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>	

	<pfs:currencyfield name="principal" 
		labelKey="subastas.editarIncormacionCierre.principalDemanda" 
		label="**Principal demanda" value="${dto.principalDemanda}"
		obligatory="true" />
		
	<pfs:currencyfield name="costasLetrado" 
		labelKey="subastas.editarIncormacionCierre.costas.letrado" 
		label="**Costas Letrado" value="${dto.costasLetrado}"
		obligatory="true" />
		
	<pfs:currencyfield name="costasProcurador" 
		labelKey="subastas.editarIncormacionCierre.costas.procurador" 
		label="**Costas Procurador" value="${dto.costasProcurador}"
		obligatory="true" />
		
	var fechaSenyalamiento = new Ext.ux.form.XDateField({
			width:100
			,height:20
			,name:'fechaSenyalamiento'
			,fieldLabel:'<s:message code="subastas.editarIncormacionCierre.fecha.senyalamiento" text="**Fecha se&ntilde;alamiento" />'
			,value:'<fwk:date value="${dto.fechaSenyalamiento}" />'
		});
		
	var diccionarioRecord = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'codigo'}
		,{name : 'descripcion'}
	]);
	
	var sinoStore = page.getStore({
		flow : 'subasta/getDiccionario'
		,storeId : 'sinoStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	sinoStore.webflow({diccionario: 'es.capgemini.pfs.procesosJudiciales.model.DDSiNo'});
	
	var cmbConPostores = new Ext.form.ComboBox({
		store: sinoStore
		,allowBlank: false
		,blankElementText: '--'
		,displayField: 'descripcion'
		,valueField: 'codigo'
		,fieldLabel:'<s:message code="subastas.editarIncormacionCierre.postores.con" text="**Con postores"/>'
		,hiddenName:'cmbConPostores'
		,width:100
		,resizable: true
		,mode: 'local'
		,triggerAction : 'all'
		,value : '${dto.conPostores}' == '' ? '' : '${dto.conPostores}' == 'true' ? 'Si' : 'No'
	});
	
	var codPlaza = '';
	var codJuzgado='';
	
	var decenaInicio = 0;
	
	var dsplazas = new Ext.data.Store({
		autoLoad: false,
		baseParams: {limit:10, start:0},
		proxy: new Ext.data.HttpProxy({
			url: page.resolveUrl('subasta/plazasPorDescripcion')
		}),
		reader: new Ext.data.JsonReader({
			root: 'plazas'
			,totalProperty: 'total'
		}, [
			{name: 'codigo', mapping: 'codigo'},
			{name: 'descripcion', mapping: 'descripcion'}
		])
	});
	
	
	var idTipoPlaza = new Ext.form.ComboBox ({
		store:  dsplazas,
		allowBlank: false,
		blankElementText: '--',
		disabled: false,
		displayField: 'descripcion', 	// descripcion
		valueField: 'codigo', 		// codigo
		fieldLabel: '<s:message code="subastas.editarIncormacionCierre.plaza.juzgado" text="**Plaza de Juzgado" />',		// Pla de juzgado
		hiddenName:'tipoPlaza',
		loadingText: 'Searching...',
		width: 200,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local',
		value:'${dto.idPlazaJuzgado}'
	});	
	
	
	codPlaza='${dto.codigoPlaza}';
	codJuzgado='${dto.codigoJuzgado}';

	var idTipoJuzgadoRecord = Ext.data.Record.create([
		{name:'id'}
		,{name:'descripcion'}
	]);
	
	var idTipoJuzgadoStore = page.getStore({
		flow:'subasta/buscarJuzgadosPlaza'
		,reader: new Ext.data.JsonReader({
			idProperty: 'codigo'
			,root:'juzgado'
		},idTipoJuzgadoRecord)
	});
	
	var idTipoJuzgado =new Ext.form.ComboBox({
		store: idTipoJuzgadoStore
		,allowBlank: false
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'id'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="subastas.editarIncormacionCierre.tipo.juzgado" text="**Tipo de Juzgado" />'
		,width:200
		,value:'${dto.idTipoJuzgado}'
		
	});
	
	if (idTipoPlaza.getValue()!=null && idTipoPlaza.getValue()!=''){
		idTipoJuzgadoStore.webflow({codigo:idTipoPlaza.getValue()});
	}
	
	idTipoJuzgadoStore.on('load', function(){  
            idTipoJuzgado.setValue(${dto.idTipoJuzgado});
       });
	 
	Ext.onReady(function() {
		decenaInicio = 0;
		if (codPlaza!=''){
			Ext.Ajax.request({
					url: page.resolveUrl('subasta/buscaPlazasPorCod')
					,params: {codigo: codPlaza}
					,method: 'POST'
					,success: function (result, request){
						var r = Ext.util.JSON.decode(result.responseText)
						decenaInicio = (r.paginaParaPlaza);
						dsplazas.baseParams.start = decenaInicio;	
						idTipoPlaza.store.reload();
						dsplazas.on('load', function(){ 
							idTipoPlaza.setValue(codPlaza);
							dsplazas.events['load'].clearListeners();
						});
					}				
			});
		}
	});
	
	idTipoPlaza.on('afterrender', function(combo) {
		combo.mode='remote';	
	}); <%----%>
	
	var recargarIdTipoJuzgado = function(){
		idTipoJuzgado.store.removeAll();
		idTipoJuzgado.clearValue();
		idTipoJuzgadoStore.on('load',function(){
		idTipoJuzgado.setValue();
		});
		if (idTipoPlaza.getValue()!=null && idTipoPlaza.getValue()!=''){
			idTipoJuzgadoStore.webflow({codigo:idTipoPlaza.getValue()});
		}
	}
		
	idTipoPlaza.on('select', function(){
		recargarIdTipoJuzgado();
		idTipoJuzgado.setDisabled(false);
	});
	
	var getParametros = function() {
	 	var p = {};
	 	p.idSubasta = ${dto.idSubasta};
	 	p.principalDemanda = principal.getValue() ? principal.getValue() : '';
	 	p.idPlazaJuzgado = idTipoPlaza.getValue() ? idTipoPlaza.getValue() : '';
	 	p.idTipoJuzgado = idTipoJuzgado.getValue() ? idTipoJuzgado.getValue() : '';
	 	p.fechaSenyalamiento = fechaSenyalamiento.getValue() ? fechaSenyalamiento.getValue() : '';
	 	p.costasLetrado = costasLetrado.getValue() ? costasLetrado.getValue() : '';
	 	p.costasProcurador = costasProcurador.getValue() ? costasProcurador.getValue() : '';
	 	p.conPostores = cmbConPostores.getValue() ? cmbConPostores.getValue() : '';
	    return p;
	}  					
	 	
 	var btnGuardar = new Ext.Button({
       text:  '<s:message code="app.guardar" text="**Guardar" />'
       ,iconCls : 'icon_ok'
       ,handler:function(){
			var p = getParametros();
			page.webflow({
	      		flow:'subasta/saveDatosEditarInformacionCierre'
	      		,params: p
	      		,success: function(){
	            	page.fireEvent(app.event.DONE);
	            }
	      	});
     	}
    });
    

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	var panelEdicion = new Ext.form.FormPanel({
		bodyStyle : 'padding:10px'
		,autoHeight : true
		,items : [{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:3}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,columnWidth:.5
						,items:[idTipoPlaza,idTipoJuzgado, principal]
					},{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,columnWidth:.5
						,items:[costasLetrado, costasProcurador, fechaSenyalamiento]
					},{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,columnWidth:.5
						,items:[cmbConPostores]
					}
				]
			}
		]
		,bbar : [btnGuardar, btnCancelar]
	});

	page.add(panelEdicion);
	
</fwk:page>