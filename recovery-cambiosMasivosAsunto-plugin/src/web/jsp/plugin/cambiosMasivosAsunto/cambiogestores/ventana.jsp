<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<fwk:page>
	var comboWidth = 300;
	var fieldSetsWidth = 430;

	 	
	var tipoGestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);

	var comboTipoGestorStore = page.getStore({
		reader: new Ext.data.JsonReader({
			root : 'data'
	      }, tipoGestor)
	     }); 


	var cargaComboTipoGestor = function() {
	     var tipoGestorJSON = <json:array name="data"
		items="${tiposGestor}" var="rec">
		<json:object>
			<json:property name="id" value="${rec.id}" />
			<json:property name="descripcion" value="${rec.descripcion}" />
		</json:object>
	</json:array>
	     comboTipoGestorStore.loadData({data:tipoGestorJSON});
	}
	cargaComboTipoGestor.defer(1);

	var comboTipoGestor = new Ext.form.ComboBox({
		store:comboTipoGestorStore
		,displayField:'descripcion'
		,valueField:'id'
		,mode: 'local'
		,width: comboWidth
		,resizable: true
		,forceSelection: true
		,editable: false
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message
		code="plugin.cambiosMasivosAsuntos.cambiogestores.tipoGestor"
		text="**Tipo de gestor" />'
		,allowBlank : false
	});
	
	
	//store generico de combo diccionario
	var optionsDespachosRecord = Ext.data.Record.create([
		 {name:'cod'}
		,{name:'descripcion'}
	]);
	
	var optionsDespachoStoreOriginal = page.getStore({
	       flow: 'coreextension/getListTipoDespachoData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoDespachos'
	    }, optionsDespachosRecord)	       
	});
	
	var optionsDespachoStoreDestino = page.getStore({
	       flow: 'coreextension/getListTipoDespachoData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoDespachos'
	    }, optionsDespachosRecord)	       
	});
	

	var comboDespachosOriginal = new Ext.form.ComboBox({
		store:optionsDespachoStoreOriginal
		,displayField:'descripcion'
		,valueField:'cod'
		,mode: 'remote'
		,emptyText:'---'
		,editable: false
		,triggerAction: 'all'
		,disabled:true
		,resizable:true
		,fieldLabel : '<s:message code="asuntos.busqueda.filtro.despacho" text="**Despacho"/>'
		<app:test id="comboDespachos" addComa="true"/>
	});
	
	var comboDespachosDestino = new Ext.form.ComboBox({
		store:optionsDespachoStoreDestino
		,displayField:'descripcion'
		,valueField:'cod'
		,mode: 'remote'
		,emptyText:'---'
		,editable: false
		,triggerAction: 'all'
		,disabled:true
		,resizable:true
		,fieldLabel : '<s:message code="asuntos.busqueda.filtro.despacho" text="**Despacho"/>'
		<app:test id="comboDespachos" addComa="true"/>
	});
	 
	 
	var Gestor = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsGestorOriginalStore = page.getStore({
	       flow: 'cambiomasivogestoresasunto/buscaGestoresByDespachoTipoGestor'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	       
	});
	 
	var optionsGestorDestinoStore = page.getStore({
	       <%-- flow: 'asuntos/buscarGestores'--%>
	       flow: 'cambiomasivogestoresasunto/buscaGestoresByDespachoTipoGestor'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	       
	});		
		
  var comboGestorOriginal = new Ext.form.ComboBox({
		store:optionsGestorOriginalStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'local'
		,width: comboWidth
		,resizable: true
		,forceSelection: true
		,editable: false
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message
		code="plugin.cambiosMasivosAsuntos.cambiogestores.usuario"
		text="**Usuario" />'
		,allowBlank : false
		,disabled: true
	});
	 
	var comboGestorDestino = new Ext.form.ComboBox({
		store:optionsGestorDestinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'local'
		,width: comboWidth
		,resizable: true
		,forceSelection: true
		,editable: false
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message
		code="plugin.cambiosMasivosAsuntos.cambiogestores.usuario"
		text="**Usuario" />'
		,allowBlank : false
		,disabled: true
	});
	 
	
	<%---------------------------------------------------------------
	var usuarioTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{nombre}</p>',
            '<p align="right"><i>{username}</i></p>',
        '</div></tpl>'
    );
	
	var gestorOrigenBuscadorStore = page.getStore({
        flow:'cambiomasivogestoresasunto/getUsuariosInstant'
        ,remoteSort:false
        ,autoLoad: false
        ,reader : new Ext.data.JsonReader({
            root:'data'
            ,fields:['nombre','username','tieneEmail']
        })
    });
	
	var comboGestorOriginal = new Ext.form.ComboBox({
        name: 'gestorOrigen' 
        ,store:gestorOrigenBuscadorStore
        ,width:comboWidth
        ,fieldLabel: '<s:message code="plugin.cambiosMasivosAsuntos.cambiogestores.usuario" text="**Usuario"/>'
        ,tpl: usuarioTemplate  
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,anchor: '100%'
        ,allowBlank:false
        ,enableKeyEvents: true
        ,typeAhead: false
        ,hideTrigger:true     
        ,minChars: 3 
        ,hidden:true
        ,maxLength:256 
        ,itemSelector: 'div.search-item'
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,onSelect: function(record) { 
            var store = gridUsuarios.getStore();
          
            var rec = store.getById(record.id);
            if (!rec) {
            	
                var data = {data:[{
                        id: record.id
                        ,nombre:record.data.nombre
                        ,incorporar:0
                        ,fecha:null
                        ,email:0
                        ,tieneEmail :record.data.tieneEmail
                        
                }]
                };
                gridUsuarios.getStore().loadData(data, true);
                comboUsuarios.collapse();
                comboUsuarios.hide();
            }
         }
    });
	
	--------------------------------------------------------------- --%>
	
	var hoy = new Date();
	var tomorrow = hoy.add(Date.DAY, 1);
	
	var fechaInicio = new Ext.ux.form.XDateField({
        name : 'fechaInicio'
        ,fieldLabel : '<s:message
		code="plugin.cambiosMasivosAsuntos.cambiogestores.fechaInicio"
		text="**Desde" />'
        ,value : ''
        ,allowBlank : false
        ,width:125
        ,disabled: true
        ,minValue: tomorrow
    });
    
    var fechaFin = new Ext.ux.form.XDateField({
        name : 'fechaFin'
        ,fieldLabel : '<s:message
		code="plugin.cambiosMasivosAsuntos.cambiogestores.fechaFin"
		text="**Hasta" />'
        ,value : ''
        ,allowBlank : true
        ,width:125
        ,disabled:true
    });
	
	
	var camposRellenos = function(){
		return comboTipoGestor.getValue() 
				&& comboGestorOriginal.getValue()
				&& comboGestorDestino.getValue() 
				&& fechaInicio.getValue()<%--
				&& fechaFin.getValue()--%>  
				&& comboDespachosOriginal.getValue() 
				&& comboDespachosDestino.getValue(); 
	}
	
	
	var createParams = function(){
		var p ={
			tipoGestor:comboTipoGestor.getValue()
			,idGestorOriginal:comboGestorOriginal.getValue()
			,idNuevoGestor:comboGestorDestino.getValue()
			,fechaInicio:fechaInicio.getValue().format('d/m/Y')
		};
		if (fechaFin.getValue()){
			p.fechaFin = fechaFin.getValue().format('d/m/Y');
		}
		
		return p;			
	}
	
	var grabaLasPeticiones = function(){
				Ext.Ajax.request({
					url: page.resolveUrl('cambiomasivogestoresasunto/anotarCambiosPendientes')
					,params: createParams()
					,method: 'POST'
					,success: function (result, request){
						var r = Ext.util.JSON.decode(result.responseText);
						if (r.success){
							Ext.Msg.alert('Correcto', 'Las peticiones han sido almacenadas.');
						}else{
							Ext.Msg.alert('Error', 'Ha ocurrido un error inesperado y no ha sido posible grabar las peticiones');
						}
					}
				}); 
	}
	
	var mismosDespachos = function(){
		if (comboDespachosOriginal.getValue()){
			if (comboDespachosDestino.getValue()){
				var b = comboDespachosOriginal.getValue() == comboDespachosDestino.getValue();
				if (! b){
					Ext.Msg.alert('Incoherencia de datos', 'El despacho/grupo debe coincidir para cambiar este tipo de gestor.');
				}
				return b;
			}else{
				return true;
			}
		}else{
			return true;
		}
	}
	
	var despachosCompatibles = function(){
		if (comboTipoGestor.getValue()){
			switch (comboTipoGestor.getValue()) {
				case 3: return mismosDespachos();
					break;
				case 4: return mismosDespachos();
					break;
				default: return true;	
			}			
		}else{
			return true;
		}
	};
	
	var btnAceptar = new Ext.Button({
       text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
       		if (despachosCompatibles()){
       			if (camposRellenos()){
 					Ext.Ajax.request({
						url: page.resolveUrl('cambiomasivogestoresasunto/comprobarCambiosPendientes')
						,params: createParams()
						,method: 'POST'
						,success: function (result, request){
							var r = Ext.util.JSON.decode(result.responseText);
							var msg = null;
							var buttons = null;
							var icon = null;
							var count = r.count;
			
							if (count && (count > 0)){
								msg = 'Los cambios van a afectar a ' + count + ' asuntos. �Desea guardarlos?';
								buttons = Ext.Msg.YESNO;
								icon = Ext.MessageBox.QUESTION;
							}else{
								msg = 'No se han encontrado asuntos que cumplan �ste criterio';
								buttons = Ext.Msg.OK;
								icon = Ext.MessageBox.ALERT;
							}
							Ext.Msg.show({
			   					title:'Confirmaci�n',
			   					msg: msg,
			   					buttons: buttons,
			   					animEl: 'elId',
			   					width:450,
			   					fn: function(result){
			   						if (result == 'yes'){
				   						grabaLasPeticiones();
					   				}
				   				},
				   				icon: icon
							});
						}
					}); 
				}else{
					Ext.Msg.alert('Faltan datos', 'Debe rellenar todos los campos de la ventana.');
				}
			}
     	}		
	});
	
	var btnCancelar = new Ext.Button({
	       text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	      		page.fireEvent(app.event.CANCEL);
	     	}
	});
			    
 
	var panelEdicion =  new Ext.Container({
		layout: 'form'
		,style: 'margin:10px'
		,defaults:{xtype:'fieldset'}	
		,items : [
		    {
				title:'<s:message
		code="plugin.cambiosMasivosAsuntos.cambiogestores.gestorOriginal"
		text="**Gestor original" />'
				,width: fieldSetsWidth
				,items:[comboTipoGestor, comboDespachosOriginal, comboGestorOriginal]
			}
			, {
				title:'<s:message
		code="plugin.cambiosMasivosAsuntos.cambiogestores.gestorDestino"
		text="**Cambiar por" />'
				,width: fieldSetsWidth
				,items:[comboDespachosDestino,comboGestorDestino]
			}
			, {
				title:'<s:message
		code="plugin.cambiosMasivosAsuntos.cambiogestores.fechas"
		text="**Entre las fechas" />'
				,width: fieldSetsWidth
				,items:[fechaInicio, fechaFin]
			}
  		]
	});	
	
	<%-- comboGestorOriginal.show();--%>
	
	comboTipoGestor.on('select', function(){
		comboDespachosOriginal.reset();
		optionsDespachoStoreOriginal.webflow({'idTipoGestor': comboTipoGestor.getValue(), 'incluirBorrados': true}); 
		
		comboDespachosDestino.reset();
		optionsDespachoStoreDestino.webflow({'idTipoGestor': comboTipoGestor.getValue(), 'incluirBorrados': true}); 

		comboGestorOriginal.reset();
		comboGestorOriginal.setValue('');
		optionsGestorOriginalStore.removeAll();
		
		comboGestorDestino.reset();
		comboGestorDestino.setValue('');
		optionsGestorOriginalStore.removeAll();
		optionsGestorDestinoStore.removeAll();

		comboDespachosOriginal.setDisabled(false);		
		comboDespachosDestino.setDisabled(false);		
		if (this.value) {
			comboDespachosOriginal.setDisabled(false);
			comboDespachosDestino.setDisabled(false);
		}else{
			comboDespachosOriginal.setDisabled(true);
			comboDespachosDestino.setDisabled(true);
		}
	});
	
	comboDespachosOriginal.on('select',function(){
		if (this.value){
			comboGestorOriginal.setDisabled(false);
			optionsGestorOriginalStore.webflow({despacho:this.value, tipoGestor:this.tipoGestor});
		}else{
			comboGestorOriginal.setDisabled(true);
		}
	});
	
	optionsGestorOriginalStore.on('load',function(){
		if (this.getCount() < 1){
			Ext.Msg.alert('Sin gestores', 'No se han encontrado gestores de �ste tipo en el despacho.');
		}
	});
	
	comboGestorOriginal.on('select', function(){
		if (this.value){
			comboDespachosDestino.setDisabled(false);
		}else{
			comboDespachosDestino.setDisabled(true);
		}
	});
	
	comboDespachosDestino.on('select',function(){
		if (this.value){
			<%--optionsGestorDestinoStore.webflow({id:this.value}); --%>
			optionsGestorDestinoStore.webflow({despacho:this.value});
			comboGestorDestino.setDisabled(false);
		}else{
			comboGestorDestino.setDisabled(true);
		}
	});
	
	comboGestorDestino.on('select', function(){
		if (this.value){
			fechaInicio.setDisabled(false);
		}else{
			fechaInicio.setDisabled(true);
		}
	});
	 
	fechaInicio.on('select',function(){
		if (this.value){
			fechaFin.setDisabled(false);
			fechaFin.minValue = this.getValue().add(Date.DAY,1);
		}else{
			fechaFin.setDisabled(true);
		}
	});
	 
	 var panelContenedor = new Ext.Panel({
	 	height:400
	 	,layout : 'column'
		,viewConfig : { columns : 1 }
		,items : [			
			panelEdicion]
		,bbar:[btnAceptar, btnCancelar]
	 });

	    
   	page.add(panelContenedor);
</fwk:page>
