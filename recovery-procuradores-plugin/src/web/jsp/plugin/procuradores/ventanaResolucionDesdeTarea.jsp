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

	var factoriaFormularios = new es.pfs.plugins.procuradores.FactoriaFormularios();
	var controlador = new es.pfs.plugins.procuradores.ControladorAsincrono();
	
	var ayuda= {html:'<div style="font-size:12px;">${html}</div>', border:false};

	
	var muestraBotonGuardar = 0;
	var validacion= {html:'<div id="validacionCMPS" style="font-size:12px;"> ${validacion}</div>', border:false, bodyStyle:'color:red;margin-bottom:5px'};
	
	 
	<c:if test="${validacion==null}">
		muestraBotonGuardar=1;
	</c:if>
	
	var uploading = false;
	
	var datosResolucion = new Ext.form.FieldSet({
        autoHeight:'false'
        ,style:'padding:2px'
        ,title:'Datos de la Resoluci&oacute;n'
        ,hidden:false
        ,border:true
        ,layout : 'column'
        ,layoutConfig:{
            columns:2
        }
        ,width:810
        ,defaults : {layout:'form',border: false,bodyStyle:'padding:3px'} 
        ,items : [ 
        
        		{
        			width:400
               	},
               	{
               		width:400
               	},
				{
					xtype:'hidden'
					,name:'idProcedimiento'
					,value:'${idProcedimiento}'
        		 },
        		 {
					xtype:'hidden'
					,name:'idTarea'
					,value:'${idTarea}'
        		 },
        		 {
					xtype:'hidden'
					,name:'idTipoResolucion'
					,value:'${idTipoResolucion}'
        		 },
        		 {
					xtype:'hidden'
					,name:'idFichero'
					,value:''
        		 }
        ]
    }); 
    
    datosResolucion.doLayout();
    datosResolucion.add(factoriaFormularios.getFormItems('${idTipoResolucion}','${idAsunto}', '${codigoTipoProc}', '${codigoPlaza}','${idProcedimiento}'));
    
    

    Ext.Ajax.request({
				url: '/pfs/pcdprocesadoresoluciones/cargaResolucion.htm'
				,params: {idResolucion: ${idResolucion}}
				,method: 'POST'
				,success: function (result, request){
				
					var r = Ext.util.JSON.decode(result.responseText);
					
					panelEdicion.getForm().reset();
					
					panelEdicion.getForm().setValues(r.resolucion);
					var nombreAdjunto = panelEdicion.getForm().findField('file').getValue('file');
					//var tipoAdjunto = panelEdicion.getForm().findField('file').getValue('type');
					
					if(nombreAdjunto !=  "No se ha adjuntado ningún fichero.")
					{
						panelEdicion.getForm().findField('file').setValue("<a href='/pfs/procuradores/descargarAdjunto.htm?idResolucion="+${idResolucion}+"')>"+nombreAdjunto+"</a>"); 			
					}
					
					var itemsFormPanel = panelEdicion.getForm().items.items;
					for (i = 0; i < itemsFormPanel.length; i++) {
						if ((itemsFormPanel[i].isXType('combo')) && (itemsFormPanel[i].name.substring(0,2) == "d_")) {
							itemsFormPanel[i].fireEvent('select',itemsFormPanel[i]);
						}
					}
					
					factoriaFormularios.updateStores('${idTipoResolucion}');
				}
				,error : function (result, request){
					factoriaFormularios.updateStores('${idTipoResolucion}');
					alert("error guardarYProcesar");
				}
			});
    

	
	var btnCancelar= new Ext.Button({
			text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
			,handler : function(){
				page.fireEvent(app.event.CANCEL);
		}
	});
	
	if (muestraBotonGuardar==1){
		var btnGuardar = new Ext.Button({
			//text : '<s:message code="app.guardar" text="**Guardar y procesar" />'
			text : 'Guardar y procesar'
			,iconCls : 'icon_ok'
			,disabled:false
		});
	}else{
			var btnGuardar = new Ext.Button({
				//text : '<s:message code="app.guardar" text="**Guardar y procesar" />'
				text : 'Guardar y procesar'
				,iconCls : 'icon_ok'
				,disabled:true
			});
	}
	
	btnGuardar.on('click', function(){
		var valores = panelEdicion.getForm().getFieldValues();
		valores['idResolucion'] = ${idResolucion};
		//debugger;
		var formulario = panelEdicion.getForm();
		
		var nombreAdjunto = panelEdicion.getForm().findField('file').getValue('file');
		
		////Al gestor se le permite guardar sin adjuntar
		Ext.getCmp('file_upload_ok').setValue('ok');
		
		if (formulario.isValid()){
			panelEdicion.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
<%--			Ext.Ajax.request({ --%>
<%--				url: '/pfs/pcdprocesadoresoluciones/dameValidacionJBPM.htm' --%>
<%-- 				,params: {idResolucion: ${idResolucion}} --%>
<%--				,method: 'POST' --%>
<%--				,success: function (result, request){ --%>
<%--					var r = Ext.util.JSON.decode(result.responseText); --%>
<%--					if (r.resultadoDatosvalidacion.validacion == "" ){ --%>
							Ext.Ajax.request({
								url: '/pfs/pcdprocesadoresoluciones/procesar.htm'
								,params: valores
								,method: 'POST'
								,success: function (result, request){
								debugger;
									var r = Ext.util.JSON.decode(result.responseText);
									if (r.resultadoDatosvalidacion.validacion == ""){
										panelEdicion.container.unmask();
 		 								page.fireEvent(app.event.DONE);
	 								}else{
										Ext.fly('validacionCMPS').dom.innerHTML = Ext.util.Format.htmlDecode(r.resultadoDatosvalidacion.validacion);
										panelEdicion.container.unmask();
	 								}
								},error: function(result, request){
									panelEdicion.container.unmask();
									alert("Error procesar");
								},failure: function(result, request){
									panelEdicion.container.unmask();
									debugger;
									alert("Error procesar");
								}
							});
<%--					}else{ --%>
<%--						Ext.fly('validacionCMPS').dom.innerHTML = Ext.util.Format.htmlDecode(r.resultadoDatosvalidacion.validacion); --%>
<%--						panelEdicion.container.unmask(); --%>
<%--					} --%>
					
<%--				} --%>
<%--				,error: function(result, request){ --%>
<%--					panelEdicion.container.unmask(); --%>
<%--				} --%>
<%--			}); --%>
		
		}else{
		
			Ext.Msg.alert('Error', 'Debe rellenar los campos obligatorios.');
		
		}
		

	});
	
<%--	var btnPausar = new Ext.Button({ --%>
<%--		text : 'Pausar' --%>
<%--		,iconCls : 'icon_cancel' --%>
<%--		,disabled:false --%>
<%--	}); --%>
	
	
<%--	btnPausar.on('click', function(){ --%>
<%--		var valores = panelEdicion.getForm().getFieldValues(); --%>
<%-- 		panelEdicion.container.mask('<s:message code="fwk.ui.form.pausando" text="**Pausando" />'); --%>
<%--		Ext.Ajax.request({ --%>
<%--			url: '/pfs/pcdprocesadoresoluciones/pausar.htm' --%>
<%-- 			,params: {valores:valores, idResolucion: ${idResolucion}} --%>
<%--			,method: 'POST' --%>
<%--			,success: function (result, request){ --%>
<%--				panelEdicion.container.unmask(); --%>
<%--				page.fireEvent(app.event.CANCEL); --%>
<%--			} --%>
<%--			,error: function(result, request){ --%>
<%--				panelEdicion.container.unmask(); --%>
<%--				alert("Error pausar"); --%>
<%--			} --%>
<%--		}); --%>
<%--	}); --%>
	
	var btnRechazar = new Ext.Button({
		text : 'Rechazar'
		,iconCls : 'icon_cancel'
		,disabled:false
	});
	
	
	btnRechazar.on('click', function(){
	debugger;
		var valores = panelEdicion.getForm().getFieldValues();
		panelEdicion.container.mask('<s:message code="fwk.ui.form.rechazando" text="**Rechazando" />');
		Ext.Ajax.request({
			url: '/pfs/pcdprocesadoresoluciones/rechazar.htm'
			,params: {valores:valores, idResolucion: ${idResolucion}}
			,method: 'POST'
			,success: function (result, request){
				panelEdicion.container.unmask();
				page.fireEvent(app.event.CANCEL);
			}
			,error: function(result, request){
				panelEdicion.container.unmask();
				alert("Error rechazar");
			}
		});
	});
	
	
	var btnAdjuntar = new Ext.Button({
		text : '<s:message code="plugin.masivo.procesadoResoluciones.btnAdjuntar" text="**Adjuntar" />'
		,iconCls:'icon_editar_propuesta'
		,disabled:false
	});
	
	btnAdjuntar.on('click', function(){
		//debugger();
		creaVentanaUpload();
		upload.getForm().findField('path').reset();
		upload.getForm().reset();
		win.show();
	});	

	var bottomBar = [];

	bottomBar.push(btnGuardar);
	bottomBar.push(btnCancelar);
	bottomBar.push(btnAdjuntar);
	bottomBar.push(btnRechazar);
<%-- 	if(${permitirPausar} == true){ --%>
<%--		bottomBar.push(btnPausar); --%>
<%--	} --%>
	
<%-- 	if ('${estadoResolucion}' == 'PAU'){ --%>
<%--		btnPausar.setDisabled(true); --%>
<%--	} --%>
	
	
	var panelEdicion=new Ext.form.FormPanel({
	autoHeight:true
	,width:820
	,bodyStyle:'padding:10px;cellspacing:20px'
	//,xtype:'fieldset'
	,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
	,items:[
		{ xtype : 'errorList', id:'errorList' }
		,{
			autoHeight:true
			,layout:'table'
			,layoutConfig:{columns:1}
			,border:false
			//,bodyStyle:'padding:5px;cellspacing:20px;'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:5px'
					,autoHeight:true
					,items:[validacion, ayuda,datosResolucion]
					//,columnWidth:.5
				}
			]
		}
		
	]
	,bbar:bottomBar   
});

page.add(panelEdicion);
var nodeValue = ""; 

var upload;
var win;

var tipoFicheroRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
		
	]);
		
var tipoFicheroStore =	page.getStore({
	       flow: 'adjuntoasunto/getTiposDeFicheroAdjuntoAsunto'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, tipoFicheroRecord)
	       
	});	
	
tipoFicheroStore.webflow({idAsunto:${idAsunto}}); 

var creaVentanaUpload = function(){
	upload = new Ext.FormPanel({
        fileUpload: true
        ,height: 55
        ,autoWidth: true
        ,bodyStyle: 'padding: 10px 10px 0 10px;'
        ,defaults: {
            allowBlank: false
            ,msgTarget: 'side'
            ,height:50
        }
        ,items: [
            	{xtype:'combo'
						,name:'comboTipoFichero'
						<app:test id="tipoProcedimientoCombo" addComa="true" />
						,hiddenName:'comboTipoFichero'
						,store:tipoFicheroStore
						,displayField:'descripcion'
						,valueField:'codigo'
						,mode: 'local'
						,emptyText:'----'
						,width:250
						,resizable:true
						,triggerAction: 'all'
						,allowBlank:true
						,fieldLabel : '<s:message code="fichero.upload.tipoDocumento" text="**Tipo fichero" />'}
				,
                {xtype:'hidden',name:'idProcedimiento',hiddenName:'idProcedimiento'}
                ,{xtype: 'fileuploadfield'
                ,emptyText: '<s:message code="fichero.upload.fileLabel.error" text="**Debe seleccionar un fichero" />'
                ,fieldLabel: '<s:message code="fichero.upload.fileLabel" text="**Fichero" />'
                   ,name: 'path'
                   ,path:'root'
                   ,buttonText: ''
                   ,buttonCfg: {
                       iconCls: 'icon_mas'
                   }
                   ,bodyStyle: 'width:50px;'
          ,listeners: {
           'fileselected': function(fb, v){
		            		var node = Ext.DomQuery.selectNode('input[id='+fb.id+']');
			        		node.value = v.replace("C:\\fakepath\\","");
			        		nodeValue = node.value;
           }
          }
           }]
           ,buttons: [{
               text: 'Subir',
               handler: function(){
               //debugger;
               //controlador.nuevoProceso(comboTipoJuicioNew.getValue(),upload.getForm(), fn_nuevoProcesoOk);
               var formulario = panelEdicion.getForm();//.findField('idResolucion');
               var idProcedimiento = formulario.findField('idProcedimiento').getValue();
			   upload.getForm().findField('idProcedimiento').setValue(idProcedimiento);

               //DatosFieldSet.find('name','idResolucion')[0];//Ext.getCmp('idResolucion');
               //controlador.uploadFicheroResolucion(resolucion.getValue(), upload, fn_subirFicheroOk, fn_subirFicheroError);
               //controlador.uploadFicheroResolucionTareas(upload, fn_subirFicheroOk, fn_subirFicheroError);
                formulario.findField('file').setRawValue(nodeValue + '&nbsp;' + '<img src="/${appProperties.appName}/img/plugin/masivo/loading.gif"/>');
					
                uploading = true;

                controlador.uploadFicheroAjax(upload, fn_subirFicheroOk, fn_subirFicheroError);
		
		        //updateBotonGuardar();
		        
		        win.hide();
                
               }
           },{
               text: 'Cancelar',
               handler: function(){
                   win.hide();
               }
           }]
       });

	win =new Ext.Window({
         width:400
        ,minWidth:400
        ,height:125
        ,minHeight:125
        ,layout:'fit'
        ,border:false
        ,closable:true
        ,title:'<s:message code="adjuntos.nuevo" text="**Agregar fichero" />'
        ,iconCls:'icon-upload'
        ,items:[upload]
        ,modal : true
	});
}

var fn_subirFicheroOk = function(r){
    //debugger;
				
    uploading = true;
    
    var id = r.resultado;
    panelEdicion.getForm().findField('idFichero').setValue(id);
    panelEdicion.getForm().findField('file').setRawValue(nodeValue + '&nbsp;' + '<img src="/${appProperties.appName}/img/plugin/masivo/Ok-icon.png"/>');    
    var nombreAdjunto = panelEdicion.getForm().findField('file').getValue('file');

	panelEdicion.getForm().findField('file').setValue("<a href='/pfs/procuradores/descargarAdjunto.htm?idResolucion="+${idResolucion}+"')>"+nombreAdjunto+"</a>");
	
	            var valores = panelEdicion.getForm().getFieldValues();
				valores['idResolucion'] = ${idResolucion};

				Ext.Ajax.request({
					url: '/pfs/pcdprocesadoresoluciones/adjuntaFicheroResolucion.htm'
					,params: valores
					,method: 'POST'
					,success: function (result, request){
<%--						panelEdicion.container.unmask(); --%>
<%--						//btnCancelar.fireEvent('click',btnCancelar); --%>
<%--						page.fireEvent(app.event.DONE); --%>
							updateBotonGuardar();
					}
					,error: function(result, request){
<%--						panelEdicion.container.unmask(); --%>
<%--						alert("Error procesar"); --%>
							updateBotonGuardar();
					}
				});
    
    win.hide();
    
}

var fn_subirFicheroError = function(r){
	uploading = false;
	updateBotonGuardar();
	//Ext.Msg.alert('Error al subir el fichero', 'El fichero no se ha podido subir.');
    panelEdicion.getForm().findField('file').setRawValue(nodeValue + '&nbsp;' + '<img src="/${appProperties.appName}/img/plugin/masivo/Ok-icon.png"/>');	

}

var updateBotonGuardar  = function(){

			Ext.Ajax.request({
				url: '/pfs/pcdprocesadoresoluciones/dameValidacion.htm'
				,params: {idResolucion: ${idResolucion}}
				,method: 'POST'
				,success: function (result, request){
					var r = Ext.util.JSON.decode(result.responseText);
					if (r.resultadoDatosvalidacion.validacion == "" ){
						btnGuardar.setDisabled(false);
					}else{
						Ext.fly('validacionCMPS').dom.innerHTML = Ext.util.Format.htmlDecode(r.resultadoDatosvalidacion.validacion);
						btnGuardar.setDisabled(true);
					}
					
				}
				,error: function(result, request){
				}
			});
}


var procesarResolucion = function(id){
	debbuger;
	controlador.procesarResolucion(id, fn_procesarResolucionOk);
}

var fn_procesarResolucionOk = function(r){
	var estado = r.resolucion.estado;
	var idResolucion = r.resolucion.idResolucion;
	//var index = listaArchivosStore.find('idResolucion',idResolucion);
	//var record = listaArchivosStore.getAt(index);
	record.set('estado', estado);
	record.commit();
	//recargarGrid();
}


</fwk:page>