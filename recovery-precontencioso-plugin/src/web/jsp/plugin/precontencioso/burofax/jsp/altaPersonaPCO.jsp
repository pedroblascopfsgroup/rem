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
	
	var panelWidth=800;
	var labelStyle='width:100px';
	var idProcedimiento = '${idProcedimiento}';
	

	
	var _handler =  function() {
		    var arrayIdPersonas=new Array();
			panelEdicionPersonas.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
			recorrerPersonasStore(arrayIdPersonas);
			
			Ext.Ajax.request({
						url : page.resolveUrl('burofax/guardaPersona'), 
						params : {arrayIdPersonas:arrayIdPersonas,idProcedimiento:idProcedimiento},
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						},
					    failure: function(form, action) {
					    	panelEdicionPersonas.container.unmask();
					        switch (action.failureType) {
					            case Ext.form.Action.CLIENT_INVALID:
					                Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.camposObligatorios" text="**Debe rellenar los campos obligatorios." />');
					                break;
					            case Ext.form.Action.CONNECT_FAILURE:
					                Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.errorComunicacion" text="**Error de comunicación" />');
					                break;
					       }
						}
		
		});
		
	};

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : _handler
	});


	var recorrerPersonasStore = function(arrayIdPersonas) {
		var i=0;
		var auxId;
		
		for (i=0; i<personasStore.getCount(); i++) {
			auxId = personasStore.getAt(i).data.id;
			arrayIdPersonas.push(auxId);
			
		}
		
	}
	
	

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler:function(){
      		page.fireEvent(app.event.CANCEL);
     	}
	});

	

	var listaIdPersonas = new Ext.form.TextField({hidden:true,value:'', name:'listaIdPersonas'});
	
	var idPersona = app.creaNumber("idPersona","Id Persona","",{
		width : 100
		,allowBlank: true
		,hidden: true
	});
		
	var dniPersona_labelStyle='font-weight:bolder>;width:50px';
	var dniPersona = new Ext.ux.form.StaticTextField({
			fieldLabel : '<s:message code="rec-web.direccion.form.dniPersona" text="**NIF" />'
			,value : ''
			,name : 'dniPersona'
			,labelStyle:dniPersona_labelStyle
			,width : 100 
		});
		
	var nombrePersona_labelStyle='font-weight:bolder>;width:50px';
	var nombrePersona = new Ext.ux.form.StaticTextField({
			fieldLabel : '<s:message code="rec-web.direccion.form.nombrePersona" text="**Nombre" />'
			,value : ''
			,name : 'nombrePersona'
			,labelStyle:nombrePersona_labelStyle
			,width : 240 
	});
	
    //Template para el combo de personas
    var personaTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{nombrePersona}&nbsp;&nbsp;&nbsp;</p><p><i><s:message code="rec-web.direccion.form.dniPersona" text="**NIF" />: {dniPersona}</i></p>',
        '</div></tpl>'
    );

    //Store del combo de personas
    var personasComboStore = page.getStore({
        flow:'burofax/getPersonasInstant'
        ,remoteSort:false
        ,autoLoad: false
        ,reader : new Ext.data.JsonReader({
            root:'data'            
            ,fields:['idPersona','dniPersona','nombrePersona','personaCompleto']
        })
    });    
    
    //personasComboStore.setBaseParam('idAsunto',idAsunto);
    //Combo de personas
    var persona = new Ext.form.ComboBox({
        name: 'persona' 
        ,allowBlank:true
        ,store:personasComboStore
        ,width:240
        ,fieldLabel: '<s:message code="rec-web.direccion.form.persona" text="**Persona"/>'
        ,tpl: personaTemplate  
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,enableKeyEvents: true
        ,typeAhead: false
        ,hideTrigger:true     
        ,minChars: 8 
        ,hidden:false
        ,maxLength:256 
        ,itemSelector: 'div.search-item'
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,onSelect: function(record) {
        	idPersona.setValue(record.data.idPersona);
        	dniPersona.setValue(record.data.dniPersona);
        	nombrePersona.setValue(record.data.nombrePersona);
        	persona.setValue(record.data.personaCompleto);
			persona.collapse();
			btnIncluir.setDisabled(false);
			persona.focus();
         }
    });

	/* Grupo de controles de manejo de la lista de personas */	
	var recordPersona = Ext.data.Record.create([
		{name: 'id'},
		{name: 'dni'},
		{name: 'nombre'}
	]);
	
	var personasStore = page.getStore({
		flow:''
		,reader: new Ext.data.JsonReader({
	  		root : 'data'
		} 
		, recordPersona)
	});
	
	var personasCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="rec-web.direccion.gridPersonas.id" text="**Id" />', dataIndex : 'id' ,sortable:false, hidden:true}
		,{header : '<s:message code="rec-web.direccion.gridPersonas.dni" text="**NIF" />', dataIndex : 'dni' ,sortable:false, hidden:false, width:80}
		,{header : '<s:message code="rec-web.direccion.gridPersonas.nombre" text="**Nombre" />', dataIndex : 'nombre',sortable:false, hidden:false, width:200}
	]);
	
	var personasGrid = new Ext.grid.EditorGridPanel({
	    title : '<s:message code="rec-web.direccion.form.listaPersonas" text="**Lista Personas" />'
	    ,cm: personasCM
	    ,store: personasStore
	    ,width: 300
	    ,height: 150
	    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	    ,clicksToEdit: 1
	});

	var incluirPersona = function() {
	    var personaAInsertar = personasGrid.getStore().recordType;
   		var p = new personaAInsertar({
   			id: idPersona.getValue(),
   			dni: dniPersona.getValue(),
   			nombre: nombrePersona.getValue()
   		});
		personasStore.insert(0, p);
	}

	var btnIncluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.incluir" text="Incluir" />'
		,iconCls : 'icon_mas'
		,disabled: true
		,handler : function(){
			incluirPersona();
			persona.reset();
			idPersona.reset();
			dniPersona.reset();
			nombrePersona.reset();
			btnIncluir.setDisabled(true);
			persona.focus();
		}
	});

	var personaAExcluir = -1;
	
	personasGrid.on('cellclick', function(grid, rowIndex, columnIndex, e) {
   		personaAExcluir = rowIndex;
   		btnExcluir.setDisabled(false);
	});

	var btnExcluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.excluir" text="Excluir" />'
		,iconCls : 'icon_menos'
		,disabled: true
		,handler : function(){
			if (personaAExcluir >= 0) {
				personasStore.removeAt(personaAExcluir);
			}
			personaAExcluir = -1;
	   		btnExcluir.setDisabled(true);
	   		persona.focus();
		}
	});

	var panelEdicionPersonas = new Ext.form.FormPanel({
		autoHeight: true,
		bodyStyle:'padding:10px;cellspacing:20px'
		,width:panelWidth
		,bbar : [
			btnGuardar, btnCancelar
		]
		,items : [
			{   autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:3}
				,border:false
				,defaults : {xtype : 'fieldset', border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:1px'}
				,items:[{items: [ persona, dniPersona, nombrePersona ]}
						,{items: [ btnIncluir, idPersona, btnExcluir, listaIdPersonas ]}
						,{items: [ personasGrid ]}
				]
			}
		]
	});
	
	

	page.add(panelEdicionPersonas);
	
</fwk:page>	