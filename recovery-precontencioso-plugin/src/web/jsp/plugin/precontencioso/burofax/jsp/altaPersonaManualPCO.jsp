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
		
		for (i=0; i < personasStore.getCount(); i++) {
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
	var dniPersonaCmp = new Ext.form.TextField({
		name : 'dniPersonaCmp'
		,value : ''
		,fieldLabel : '<s:message code="rec-web.direccion.form.dniPersona" text="**NIF" />'
		,hidden: true
	});
		
	var nombrePersona_labelStyle='font-weight:bolder>;width:50px';
	var nombrePersona = new Ext.ux.form.StaticTextField({
			fieldLabel : '<s:message code="rec-web.direccion.form.nombrePersona" text="**Nombre" />'
			,value : ''
			,name : 'nombrePersona'
			,labelStyle:nombrePersona_labelStyle
			,width : 240 
	});
	var nombrePersonaCmp = new Ext.form.TextField({
		name : 'nombrePersonaCmp'
		,value : ''
		,fieldLabel : '<s:message code="rec-web.direccion.form.nombrePersona" text="**Nombre" />'
		,hidden: true
	});
	
	var apellido1Persona_labelStyle='font-weight:bolder>;width:50px';
	var apellido1Persona = new Ext.ux.form.StaticTextField({
			fieldLabel : '<s:message code="rec-web.direccion.form.primerApellido" text="**Primer apellido" />'
			,value : ''
			,name : 'apellido1Persona'
			,labelStyle:apellido1Persona_labelStyle
			,width : 240 
	});
	var apellido1PersonaCmp = new Ext.form.TextField({
		name : 'apellido1PersonaCmp'
		,value : ''
		,fieldLabel : '<s:message code="rec-web.direccion.form.primerApellido" text="**Primer apellido" />'
		,hidden: true
	});
	
	var apellido2Persona_labelStyle='font-weight:bolder>;width:50px';
	var apellido2Persona = new Ext.ux.form.StaticTextField({
			fieldLabel : '<s:message code="rec-web.direccion.form.segundoApellido" text="**Segundo apellido" />'
			,value : ''
			,name : 'apellido2Persona'
			,labelStyle:apellido2Persona_labelStyle
			,width : 240 
	});
	var apellido2PersonaCmp = new Ext.form.TextField({
		name : 'apellido2PersonaCmp'
		,value : ''
		,fieldLabel : '<s:message code="rec-web.direccion.form.segundoApellido" text="**Segundo apellido" />'
		,hidden: true
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
            ,fields:['idPersona','dniPersona','nombrePersona','personaCompleto','nombre','apellido1','apellido2']
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
        	if(record.data.idPersona == null){
	        	Ext.MessageBox.confirm("<s:message code="plugin.precontencioso.grid.burofax.aniadirNotificado.clienteNoEncontrado" text="**Cliente no encontrado" />", "<s:message code="plugin.precontencioso.grid.burofax.aniadirNotificado.deseaDarAlta" text="**No encontrado en Recovery.¿Desea dar de alta a esta persona como notificado?" />", function(resp){
					if (resp=='no'){
						return;
					}else{
						camposRegistroNoEncontrado();
						persona.reset();
						idPersona.reset();
						dniPersona.reset();
						nombrePersona.reset();
						btnIncluir.setDisabled(true);
						persona.setValue('Nueva Persona');
						persona.focus();
					 	return;
					}
				});
        	}else{
        		camposRegistroEncontrado();
        		idPersona.setValue(record.data.idPersona);
	        	dniPersona.setValue(record.data.dniPersona);
	        	nombrePersona.setValue(record.data.nombre);
	        	apellido1Persona.setValue(record.data.apellido1);
	        	apellido2Persona.setValue(record.data.apellido2);
	        	persona.setValue(record.data.personaCompleto);
				persona.collapse();
				btnIncluir.setDisabled(false);
				persona.focus();
        	}
         }
    });
    
    persona.store.on( 'load', function( store, records, options ) {
    	if(records.length == 0){
			personasComboStore.add(new personasComboStore.recordType({idPersona: null,nombrePersona: 'Nueva persona',personaCompleto:'Nueva persona'}, 0));
    	}
    	
	} );

	/* Grupo de controles de manejo de la lista de personas */	
	var recordPersona = Ext.data.Record.create([
		{name: 'id'},
		{name: 'dni'},
		{name: 'nombre'}
	]);

	var myCboxSelModel = new Ext.grid.CheckboxSelectionModel({
 		handleMouseDown : function(g, rowIndex, e){
  		 	var view = this.grid.getView();
    		var isSelected = this.isSelected(rowIndex);
    		if(isSelected) {
      			this.deselectRow(rowIndex);
    		} 
    		else if(!isSelected || this.getCount() > 1) {
      			this.selectRow(rowIndex, true);
      			view.focusRow(rowIndex);
    		}
    		
  		},
  		singleSelect: false
	});

	
	var Contrato = Ext.data.Record.create([
        {name:'idContrato'}
        ,{name:'cc'}
        ,{name:'tipo'}
        ,{name:'diasIrregular'}
        ,{name:'saldoNoVencido'}
        ,{name:'saldoIrregular'}
        ,{name:'tipointerv'}
    ]);
	
	var columnArray = [
		myCboxSelModel
		,{
			header: '<s:message code="plugin.precontencioso.grid.relacionContratos.numContrato" text="**Num Contrato"/>',
			dataIndex: 'cc', sortable: true,autoWidth:true,id:'idContrato'
		},{
			header: '<s:message code="plugin.precontencioso.grid.relacionContratos.producto" text="**Producto"/>',
			dataIndex: 'tipo', sortable: true,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.relacionContratos.diasVencido" text="**Días vencido"/>',
			dataIndex: 'diasIrregular', sortable: true,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.relacionContratos.saldoVencido" text="**Saldo vencido"/>',
			dataIndex: 'saldoNoVencido',renderer: app.format.moneyRenderer,align:'right', sortable: true,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.relacionContratos.tipoIntervencion" text="**Tipo de intervención"/>',
			dataIndex: 'tipointerv', sortable: true,autoWidth:true
		}
	];
	
	var relacionContratosStore = page.getStore({
		eventName : 'listado'
		,flow:'burofax/getRelacionContratos'
		,reader: new Ext.data.JsonReader({
			root: 'contratos'
		}, Contrato)
	});
	
	var columMemoryPlugin = new Ext.ux.plugins.CheckBoxMemory();
	 
	var gridRelacionContratos = new Ext.grid.GridPanel({
		title: '<s:message code="plugin.precontencioso.grid.relacionContratos.titulo" text="**Relacion Contratos" />'	
		,columns: columnArray
		,store: relacionContratosStore
		,height: 270
		,width: 750
		,loadMask: true
        ,sm: myCboxSelModel
        ,viewConfig: {forceFit: true}
        ,autoExpand:true
        ,clicksToEdit: 1
        ,plugins: [columMemoryPlugin]
       	,style:'padding-top:10px'
		,cls:'cursor_pointer'
		,iconCls : 'icon_contratos'
		,autoWidth: true
		,collapsible: true		
	});
	
	
	relacionContratosStore.webflow({idProcedimiento: data.precontencioso.id});

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
				,layoutConfig:{columns:1}
				,border:false
				,defaults : {xtype : 'fieldset', border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:1px'}
				,items:[{items: [ persona, dniPersona, nombrePersona, apellido1Persona, apellido2Persona, dniPersonaCmp, nombrePersonaCmp, apellido1PersonaCmp, apellido2PersonaCmp]}
						,{items: [ gridRelacionContratos ]}
				]
			}
		]
	});
	
	
	var camposRegistroEncontrado = function(){
		dniPersona.setVisible(true);
		nombrePersona.setVisible(true);
		apellido1Persona.setVisible(true);
		apellido2Persona.setVisible(true)
		dniPersonaCmp.setVisible(false);
		nombrePersonaCmp.setVisible(false);
		apellido1PersonaCmp.setVisible(false);
		apellido2PersonaCmp.setVisible(false);
		dniPersonaCmp.setValue('');
		nombrePersonaCmp.setValue('');
		apellido1PersonaCmp.setValue('');
		apellido2PersonaCmp.setValue('');
	};
	var camposRegistroNoEncontrado = function(){
		dniPersona.setVisible(false);
		nombrePersona.setVisible(false);
		apellido1Persona.setVisible(false);
		apellido2Persona.setVisible(false)
		dniPersonaCmp.setVisible(true);
		nombrePersonaCmp.setVisible(true);
		apellido1PersonaCmp.setVisible(true);
		apellido2PersonaCmp.setVisible(true);
	};
	

	page.add(panelEdicionPersonas);
	
</fwk:page>	