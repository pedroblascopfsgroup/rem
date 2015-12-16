<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<fwk:page>


    var cTipoPolitica = app.creaCombo({
        data: <app:dict value="${tiposPolitica}" />
        ,name: 'codigoTipoPolitica'
        ,allowBlank: false
        ,fieldLabel: '<s:message code="politica.tipoPolitica" text="**Tipo de política" />'
        ,value: '${dtoPolitica.politica.tipoPolitica.codigo}'
        ,valueNotFoundText : '---'
        ,validator : function(value) {return (value!=this.valueNotFoundText); }
    });

    var estadoField = new Ext.ux.form.StaticTextField({
        fieldLabel : '<s:message code="politica.estado" text="**Estado" />'
        ,value : '${dtoPolitica.politica.estadoPolitica.descripcion}'
        ,name : 'estado'
    });


    var motivoField = app.creaCombo({
    	data:<app:dict value="${motivos}"/>
    	,name : 'motivo'
    	,allowBlanck: false
    	,fieldLabel : '<s:message code="politica.motivo" text="**Motivo" />'
    	,value : '${dtoPolitica.politica.motivo.codigo}'
    });

    
    var fechaField = new Ext.ux.form.XDateField({ 
 		name : 'fecha'
 		,fieldLabel : '<s:message code="politica.fechaCreacion" text="**Fecha creación" />' 
 		,value : '<fwk:date value="${dtoPolitica.politica.auditoria.fechaCrear}"/>'
 		,width:100 
 	}); 

	


    var lGestor = app.creaLabel('<s:message code="politica.gestor" text="**Gestor"/>');

    var cPerfilGestor = app.creaCombo({
        triggerAction: 'all'
        ,data: <app:dict value="${perfiles}" />
        ,name: 'codigoGestorPerfil'
        ,allowBlank: false
        ,fieldLabel: '<s:message code="politica.perfil" text="**Perfil" />'
        ,value:'${dtoPolitica.politica.perfilGestor.codigo}'
        ,disabled:true
    });
    
    var zonasRecord = Ext.data.Record.create([
         {name:'codigo'}
        ,{name:'descripcion'}
    ]);
    
    var optionsGestorZonasStore = page.getStore({
           flow: 'politica/listadoZonas'
           ,reader: new Ext.data.JsonReader({
             root : 'zonas'
        }, zonasRecord)
           
    });

    var cZonaGestor = app.creaCombo({
        store:optionsGestorZonasStore
        ,funcionReset:function() {recargarComboZonas(cPerfilGestor, optionsGestorZonasStore);}
        ,fieldLabel: '<s:message code="politica.zona" text="**Zona" />'
        ,name:'codigoGestorZona'
        ,allowBlank: false
        ,disabled:true
    });

    var recargarComboZonas = function(combo, store){
        if (combo.getValue()!=null && combo.getValue()!=''){
            store.webflow({codPerfil:combo.getValue()});
        }else{
            store.webflow({codPerfil:0});
        }
    };

    recargarComboZonas(cPerfilGestor, optionsGestorZonasStore);
    
    var limpiarYRecargar = function(comboLimpiar, comboOrigen, store){
        app.resetCampos([comboLimpiar]);
        recargarComboZonas(comboOrigen, store);
    }
    cPerfilGestor.on('select',function() {limpiarYRecargar(cZonaGestor, cPerfilGestor, optionsGestorZonasStore)});
 
    var setearZonaGestor = function() {
        cZonaGestor.setValue('${dtoPolitica.politica.zonaGestor.codigo}');
        optionsGestorZonasStore.un('load',setearZonaGestor);
    };

    optionsGestorZonasStore.on('load', setearZonaGestor);   


    var lSupervisor = app.creaLabel('<s:message code="politica.supervisor" text="**Supervisor"/>');

    var cPerfilSupervisor = app.creaCombo({
        triggerAction: 'all'
        ,data: <app:dict value="${perfiles}" />
        ,name: 'codigoSupervisorPerfil'
        ,allowBlank: false
        ,fieldLabel: '<s:message code="politica.perfil" text="**Perfil" />'
        ,value:'${dtoPolitica.politica.perfilSupervisor.codigo}'
        ,disabled:true
    });

    var optionsSupervisorZonasStore = page.getStore({
           flow: 'politica/listadoZonas'
           ,reader: new Ext.data.JsonReader({
             root : 'zonas'
        }, zonasRecord)
           
    });

    var cZonaSupervisor = app.creaCombo({
        store: optionsSupervisorZonasStore
        ,funcionReset:function() {recargarComboZonas(cPerfilSupervisor, optionsSupervisorZonasStore);}
        ,fieldLabel: '<s:message code="politica.zona" text="**Zona" />'
        ,name:'codigoSupervisorZona'
        ,allowBlank: false
        ,value: ''
        ,disabled:true
    });

    recargarComboZonas(cPerfilSupervisor, optionsSupervisorZonasStore);
    
    
    cPerfilSupervisor.on('select',function() {limpiarYRecargar(cZonaSupervisor, cPerfilSupervisor, optionsSupervisorZonasStore);});

    var setearZonaSuper = function() {
        cZonaSupervisor.setValue('${dtoPolitica.politica.zonaSupervisor.codigo}');
        optionsSupervisorZonasStore.un('load',setearZonaSuper);
    };

	<c:if test="${isSuperusuario != null && isSuperusuario == true}">
		cPerfilGestor.enable();
		cZonaGestor.enable();
	
		cPerfilSupervisor.enable();
		cZonaSupervisor.enable();
	</c:if>


    optionsSupervisorZonasStore.on('load',setearZonaSuper);   

    		var TipoPoliticaFieldSet = new Ext.form.FieldSet({
			autoHeight:true
			,width:760
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="politica.politica" text="**Politica"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : [{items:[cTipoPolitica,estadoField]},
					  {items:[motivoField,fechaField]}
					 ]
		});
		
		   		var GestorFieldSet = new Ext.form.FieldSet({
			autoHeight:true
			,width:760
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="politica.gestor" text="**Gestor"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : [{items:[cPerfilGestor]},
					  {items:[cZonaGestor]}
					 ]
		});
    
    	   	var SupervisorFieldSet = new Ext.form.FieldSet({
			autoHeight:true
			,width:760
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="politica.supervisor" text="**Supervisor"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : [{items:[cPerfilSupervisor]},
		   			  {items:[cZonaSupervisor]}
					 ]
		});
		
		var items={
			
			//,layout:'anchor'
			//,region: 'south'
			layout:'table'
			,border : false
		    ,layoutConfig: {
		        // The total column count must be specified here
		        columns: 1
		    }
			,autoScroll:true
			,bodyStyle:'padding:5px;margin:5px'
			,autoHeight:true
			,autoWidth : true
			,items:[
				TipoPoliticaFieldSet
				,GestorFieldSet
				,SupervisorFieldSet
				
			]
			
		};
    
    


    app.crearABMWindow(page , items);
</fwk:page>