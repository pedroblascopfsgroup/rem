<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<fwk:page>
	var width=200;
	var style='text-align:left;font-weight:bolder;width:100';
	
	
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,disabled:true
		,handler : function(){
			if(validar()){
			page.submit({
					 eventName : 'saveOrUpdate'
					,formPanel : panelEdicion
					,success : function(){page.fireEvent(app.event.DONE) }
					,params:crearParametros()
				});
			}
			
			
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	var comboValoraciones = app.creaCombo({
		data : <app:dict value="${valoraciones}"/>
		,allowBlank:false
		,name : 'codigoValoracion'
		,fieldLabel : '<s:message code="analisisPersona.valoraciones" text="**Tipo Valoración" />'
		,labelStyle:style
		//revisar analisisPO
		,typeAhead: false
        ,mode: 'local'
        ,triggerAction: 'all'
        ,editable: false
        ,selectOnFocus:true
	});

	
	var comboImpacto = app.creaCombo({
		data : <app:dict value="${impactos}"/>
		,allowBlank:false
		,name : 'codigoImpacto'
		,fieldLabel : '<s:message code="analisisPersonas.impactos" text="**Tipo Impacto"/>'
		,labelStyle:style
		//revisar analisisPO		
		,typeAhead: false
        ,mode: 'local'
        ,triggerAction: 'all'
        ,editable: false
        ,selectOnFocus:true
	});
	var validar=function(){
		for(i=0;i < analisisOperacionesStore.getCount();i++){
			var rec=analisisOperacionesStore.getAt(i);
			var valoracion=rec.get('codigoValoracion');
			var impacto=rec.get('codigoImpacto');
			if(valoracion!='' && impacto==''){
				Ext.Msg.alert('','Completar el campo Impacto');
				return false;
			}
			if(valoracion=='' && impacto!=''){
				Ext.Msg.alert('','Completar el campo Impacto');
				return false;
			}
		}
		return true;
		
	}
	
	var analisisOperaciones = Ext.data.Record.create([
         {name : 'id'}
		,{name : 'idContrato'}
		,{name : 'contrato'}
        ,{name : 'tipoContrato'}
        ,{name : 'valoracion'}
        ,{name : 'codigoValoracion'}
        ,{name : 'codigoImpacto'}
        ,{name : 'impacto'}
        ,{name : 'comentario'}
    ]);
	
	var crearParametros=function(){
		var param={}
		var counterArray=0;
		
		var listadoId = '';
		var listadoIdPersonas = '';
		var listadoIdContratos = '';
		var listadoCodigoImpactos = '';
		var listadoCodigoValoraciones = '';
			
		for(i=0;i < analisisOperacionesStore.getCount();i++){
			var rec=analisisOperacionesStore.getAt(i);
			
			if(rec.isModified('codigoImpacto') || rec.isModified('codigoValoracion')){
			
				if (counterArray > 0)
				{	
					listadoId += ',';
					listadoIdPersonas += ',';
					listadoIdContratos += ',';
					listadoCodigoImpactos += ',';
					listadoCodigoValoraciones += ',';
				}

				if (rec.get('id') == '' || rec.get('id') == null) listadoId += ' ';
				else listadoId += rec.get('id');				
				listadoIdPersonas += '${idPersona}';
				listadoIdContratos += rec.get('idContrato');
				listadoCodigoImpactos += rec.get('codigoImpacto');
				listadoCodigoValoraciones += rec.get('codigoValoracion');
				
				
				counterArray++;
			}
		}

		param["listadoId"]=listadoId;
		param["listadoIdPersonas"]=listadoIdPersonas;
		param["listadoIdContratos"]=listadoIdContratos;
		param["listadoCodigoImpactos"]=listadoCodigoImpactos;
		param["listadoCodigoValoraciones"]=listadoCodigoValoraciones;
		
		
		return param;
	}
    analisisOperacionesStore = page.getStore({
        event:'listado'
        ,flow : 'politica/analisisOperaciones'
        ,reader : new Ext.data.JsonReader(
            {root:'listadoAnalisisOperaciones'}
            , analisisOperaciones
        )
    });
	//analisisOperacionesStore.on('datachanged',btnGuardar.setEnabled(true));
	var valoracionRenderer=function(v){
		var store=comboValoraciones.getStore();
		for(i=0;i < store.getCount();i++){
			var rec=store.getAt(i);
			if(v==rec.get('codigo'))
				return rec.get('descripcion')
		}
	}
	var impactoRenderer=function(v){
		var store=comboImpacto.getStore();
		for(i=0;i < store.getCount();i++){
			var rec=store.getAt(i);
			if(v==rec.get('codigo'))
				return rec.get('descripcion')
		}
	}

    var analisisOperacionesCm = new Ext.grid.ColumnModel([                                                                                                                         
         {
		 	header : '<s:message code="analisisOperaciones.contrato" text="**Contrato" />'
			,dataIndex : 'contrato'
			
		}
        ,{header : '<s:message code="analisisOperaciones.tipoContrato" text="**Tipo Contrato" />', dataIndex : 'tipoContrato'}
        ,{
			header: '<s:message code="politica.valoracion" text="**Valoraci&oacute;n" />'
			,dataIndex: 'codigoValoracion'
			,renderer:valoracionRenderer
			,editor: comboValoraciones
		}
        ,{
			header : '<s:message code="politica.impacto" text="**Impacto" />'
			,dataIndex : 'codigoImpacto'
			,renderer:impactoRenderer
			,editor:comboImpacto
		}
    ]);
          
	var analisisOperacionesGrid = app.crearEditorGrid(analisisOperacionesStore,analisisOperacionesCm,{
        title: '<s:message code="analisisOperaciones.titulo" text="**An&aacute;lisis Operaciones" />'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,cls:'cursor_pointer'
		,style:'padding-right:10px'
        ,iconCls:'icon_personas'
		,clicksToEdit: 1
        ,height:250
        ,parentWidth:750
    });
	
	var panelEdicion = new Ext.form.FormPanel({
		border:true
		,width:650
		,autoHeight:true
		,bodyStyle : 'padding:10px'
		,items:[analisisOperacionesGrid]
		,bbar:[btnGuardar,btnCancelar]
	});	
	analisisOperacionesStore.webflow({id:${idPersona}});
	analisisOperacionesStore.on('update',function(){
		btnGuardar.setDisabled(false);
	})
	page.add(panelEdicion);

</fwk:page>
