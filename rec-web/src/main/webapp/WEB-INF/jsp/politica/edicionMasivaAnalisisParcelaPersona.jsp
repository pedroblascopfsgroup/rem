<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<fwk:page>
	var width=300;
	var style='text-align:left;font-weight:bolder;width:140';
	

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,disabled:true
		,handler : function(){
			if (validar()){
				page.submit({
					 eventName : 'saveOrUpdate'
					,formPanel : panelEdicion
					,success: function(){page.fireEvent(app.event.DONE)	}
					,params:crearParametros() 
					
				});
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisisPersonas.faltanCampos" text="**Debe completar todos los campos"/>')
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
		,fieldLabel : '<s:message code="analisisPersona.valoraciones" text="**Tipo Valoración" />'
		,labelStyle:style
		,width:150
		,typeAhead: false
		,name : 'codigoValoracion'
        ,mode: 'local'
        ,triggerAction: 'all'
        ,editable: false
        ,selectOnFocus:true
	});

	
	var comboImpacto = app.creaCombo({
		data : <app:dict value="${impactos}"/>
		,allowBlank:false
		,width:150
		,fieldLabel : '<s:message code="analisisPersonas.impactos" text="**Tipo Impacto"/>'
		,labelStyle:style
		,name : 'codigoImpacto'
		,typeAhead: false
        ,mode: 'local'
        ,triggerAction: 'all'
        ,editable: false
        ,selectOnFocus:true
	});
	
	var validar = function(){
		for(i=0;i < analisisPersonaStore.getCount();i++){
			var rec=analisisPersonaStore.getAt(i);
			var valoracion=rec.get('codValoracion');
			var impacto=rec.get('codImpacto');
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
	
	var analisisPersona = Ext.data.Record.create([
         {name : 'id'}
		,{name : 'tipo'}
        ,{name : 'parcela'}
		,{name : 'idParcela'}
        ,{name : 'valoracion'}
        ,{name : 'codValoracion'}
        ,{name : 'codImpacto'}
        ,{name : 'impacto'}
        ,{name : 'comentario'}
        ,{name : 'none'}
    ]);

	var crearParametros=function(){
		var param={}
		var counterArray=0;
		
		var listadoId = '';
		var listadoIdPersonas = '';
		var listadoIdParcelas = '';
		var listadoCodigoImpactos = '';
		var listadoCodigoValoraciones = '';
		
		for(i=0;i < analisisPersonaStore.getCount();i++){
			var rec=analisisPersonaStore.getAt(i);
			
			if(rec.isModified('codImpacto') || rec.isModified('codValoracion')){
			
				if (counterArray > 0)
				{	
					listadoId += ',';
					listadoIdPersonas += ',';
					listadoIdParcelas += ',';
					listadoCodigoImpactos += ',';
					listadoCodigoValoraciones += ',';
				}

				if (rec.get('id') == '' || rec.get('id') == null) listadoId += ' ';
				else listadoId += rec.get('id');				

				listadoIdPersonas += '${idPersona}';
				listadoIdParcelas += rec.get('idParcela');
				listadoCodigoImpactos += rec.get('codImpacto');
				listadoCodigoValoraciones += rec.get('codValoracion');
				
				
				counterArray++;
			}
		}
		
		param["listadoId"]=listadoId;
		param["listadoIdPersonas"]=listadoIdPersonas;
		param["listadoIdParcelas"]=listadoIdParcelas;
		param["listadoCodigoImpactos"]=listadoCodigoImpactos;
		param["listadoCodigoValoraciones"]=listadoCodigoValoraciones;
		
		return param;
	}
    var analisisPersonaStore = page.getStore({
        event:'listado'
        ,flow : 'politica/analisisPersona'
        ,reader : new Ext.data.JsonReader(
            {root:'listadoAnalisis'}
            , analisisPersona
        )
    });
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
    var analisisPersonaCm = new Ext.grid.ColumnModel([                                                                                                                         
        {header : '<s:message code="analisisPersona.tipo" text="**Tipo" />', dataIndex : 'tipo', width:250}
        ,{header : '<s:message code="politica.parcela" text="**Parcela" />', dataIndex : 'parcela', width:250}
        ,{	
			header: '<s:message code="politica.valoracion" text="**Valoraci&oacute;n" />'
			,dataIndex: 'codValoracion'
			,renderer:valoracionRenderer
			,editor: comboValoraciones
			, width:100
		}
        ,{
			header : '<s:message code="politica.impacto" text="**Impacto" />'
			,dataIndex : 'codImpacto'
			,renderer:impactoRenderer
			,editor:comboImpacto
			,width:100
		}
    ]);                

	var analisisPersonaGrid = app.crearEditorGrid(analisisPersonaStore,analisisPersonaCm,{
		title: '<s:message code="analisisPersonas.titulo" text="**An&aacute;lisis de la Persona" />'        
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,cls:'cursor_pointer'
        ,iconCls:'icon_personas'
		,clicksToEdit: 1
		,width:750
        ,height:225
        ,parentWidth:750
    });

	var panelEdicion = new Ext.form.FormPanel({
		autoHeight:true
		,width:650
		,border:false
		,height: 300
		,bodyStyle : 'padding:10px'
		,items:[analisisPersonaGrid]
		,bbar:[btnGuardar,btnCancelar]
	});	
	analisisPersonaStore.webflow({id:${idPersona}});
	analisisPersonaStore.on('update',function(){
		btnGuardar.setDisabled(false);
	})

	page.add(panelEdicion);

</fwk:page>
