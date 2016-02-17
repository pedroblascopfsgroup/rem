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
	var labelStyle='width:70px';

	<pfsforms:ddCombo name="provincia"
		labelKey="rec-web.direccion.form.provincia" 
 		label="**Provincia" value="" dd="${provincias}" 
		propertyCodigo="id" propertyDescripcion="descripcion" />
	
    //provincia.labelStyle=labelStyle;	
	provincia.on('select',function(){
		if( provincia.getValue() != null && provincia.getValue() != '' ){
			localidad.reset();
			localidad.setDisabled(false);
			comboLocalidadStore.webflow({'idProvincia':  provincia.getValue() }); 
		} else{
			localidad.reset();
			localidad.setDisabled(true);
		}
	})

	<pfsforms:textfield name="codigoPostal"
			labelKey="rec-web.direccion.form.codigoPostal" label="**Código Postal"
			value="" obligatory="true" width="100" />
	
	var listadoLocalidades = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var comboLocalidadStore = page.getStore({
	       flow: 'direccion/getListLocalidades'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listaLocalidades'
	    }, listadoLocalidades)	       
	});	

	var localidad = new Ext.form.ComboBox({
		store:comboLocalidadStore
		,name:'localidad'
		,hiddenName:'localidad'
		,displayField:'descripcion'
		,valueField:'id'
		,allowBlank : false
		,mode: 'local'
		,width: 350
		,resizable: true
		,forceSelection: true
		,disabled: true
		,editable: true
		,emptyText:'<s:message code="rec-web.direccion.form.seleccionar" text="**Seleccionar" />'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="rec-web.direccion.form.localidad" text="**Localidad" />'
	});
	
	localidad.on('select',function(){
		if( localidad.getValue() != null && localidad.getValue() != '' && municipio.getValue() == ''){
			municipio.setValue(localidad.getRawValue().toUpperCase());
		}
	})

	<pfsforms:textfield name="municipio"
			labelKey="rec-web.direccion.form.municipio" label="**Municipio"
			value="" obligatory="true" width="350" />

	<pfsforms:ddCombo name="tipoVia"
		labelKey="rec-web.direccion.form.tipoVia" 
 		label="**Tipo Vía" value="" dd="${tiposVia}" 
		propertyCodigo="id" propertyDescripcion="descripcion" />

	<pfsforms:textfield name="domicilio"
			labelKey="rec-web.direccion.form.domicilio" label="**Domicilio"
			value="" obligatory="true" width="350" />
	
	<pfsforms:textfield name="numero"
			labelKey="rec-web.direccion.form.numero" label="**Número"
			value="" obligatory="false" width="50" />
	
	<pfsforms:textfield name="portal"
			labelKey="rec-web.direccion.form.portal" label="**Portal"
			value="" obligatory="false" width="50" />
	
	<pfsforms:textfield name="piso"
			labelKey="rec-web.direccion.form.piso" label="**Piso"
			value="" obligatory="false" width="50" />
	
	<pfsforms:textfield name="escalera"
			labelKey="rec-web.direccion.form.escalera" label="**Escalera"
			value="" obligatory="false" width="50" />
	
	<pfsforms:textfield name="puerta"
			labelKey="rec-web.direccion.form.puerta" label="**Puerta"
			value="" obligatory="false" width="50" />
	
var origen = app.creaText("origen","<s:message code="rec-web.direccion.form.origen" text="**Origen" />","Manual",{
	width : 100
	,readOnly: true
});
	
	var datosPrioridad = [['-1','--']];
	
	var comboPrioridad = new Ext.form.ComboBox({
			name:'comboPrioridad'
			,hiddenName:'comboPrioridad'
			,store:datosPrioridad
			,displayField:'descripcion'
			,valueField:'id'
			,mode: 'local'
			,style:'margin:0px'
			,triggerAction: 'all'
		//	,labelStyle:labelStyle
			,disabled:false
			,fieldLabel : '<s:message code="plugin.mejoras.clientes.telefonos.abmTelefonos.cboPrioridad" text="**Prioridad" />'
			,hidden: false
	});
	
	var origenesData=<app:dict value="${origenes}" />;
    var comboOrigen = app.creaCombo({
    	triggerAction: 'all', 
    	data:origenesData, 
    	value:'', 
    	name : 'origenes', 
    	fieldLabel : '<s:message code="plugin.mejoras.clientes.telefonos.abmTelefonos.cboOrigienes" text="**Origen" />',
    //	labelStyle:labelStyleFieldSet,
    	allowBlank: false
    });
    	
    
	var tiposData=<app:dict value="${tipos}" />;
    var comboTipo = app.creaCombo({
    	triggerAction: 'all', 
    	data:tiposData, 
    	value:'', 
    	name : 'tipos', 
    	fieldLabel : '<s:message code="plugin.mejoras.clientes.telefonos.abmTelefonos.cboTipos" text="**Tipo" />',
    	//labelStyle:labelStyleFieldSet,
    	allowBlank: false
    	});

	var motivosData=<app:dict value="${motivos}" />;
    var comboMotivo = app.creaCombo({
    	triggerAction: 'all', 
    	data:motivosData, 
    	value:'', 
    	name : 'motivos', 
    	fieldLabel : '<s:message code="plugin.mejoras.clientes.telefonos.abmTelefonos.cboMotivos" text="**Motivo" />',
    	//labelStyle:labelStyleFieldSet,
    	allowBlank: false
    	});

	var estadosData=<app:dict value="${estados}" />;
    var comboEstado = app.creaCombo({
    	triggerAction: 'all', 
    	data:estadosData, value:'', 
    	name : 'estados', 
    	fieldLabel : '<s:message code="plugin.mejoras.clientes.telefonos.abmTelefonos.cboEstado" text="**Estado" />',
    	//labelStyle:labelStyleFieldSet,
    	allowBlank: false
    	});
	
	var chkConsentimiento = new Ext.form.Checkbox({
         fieldLabel: '<s:message code="plugin.mejoras.clientes.telefonos.abmTelefonos.consentimiento" text="**Consentimiento"/>'
         ,inputValue: '1'
         //,labelStyle:labelStyleFieldSet
         ,hidden: false
     });
	
	var observaciones = app.crearTextArea(
		'<s:message code="plugin.mejoras.clientes.telefonos.abmTelefonos.observaciones" text="**Observaciones" />'
		,'<s:message text="${observaciones}" javaScriptEscape="true" />'
		,false
		//,labelStyleFieldSet		
		,'telefonos.observaciones'
		, {
			 maxLength:2000
			,height:80
			,width:200
		}
	);
	
	var _handler =  function() {
		if (personasStore.getCount() == 0) {
			Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.minimoPersonas" text="**Al menos debe haber una persona asignada a la dirección." />');
		} else if (provincia.getValue() == '') {
			Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.provinciaObligatoria" text="**La provincia es obligatoria." />');
			provincia.focus();
		} else if (localidad.getValue() == '') {
			Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.localidadObligatoria" text="**La localidad es obligatoria." />');
			localidad.focus();
		} else if (tipoVia.getValue() == '') {
			Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.tipoViaObligatoria" text="**El tipo de vía es obligatorio." />');
			tipoVia.focus();
		} else {
			panelEdicionExtendido.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
			recorrerPersonasStore();
			panelEdicionExtendido.getForm().submit(
			{	
			    clientValidation: true,
				url: '/'+app.getAppName()+'/direccion/guardaDireccion.htm',
				success: function(form, action) {
					if (action.result.resultado == "OK") {
						Ext.Msg.alert('', '<s:message code="rec-web.direccion.resultado.OK" text="**Se ha creado correctamente la dirección introducida." />');
					} else {
						Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.resultado.KO" text="**Se han producido errores al crear la dirección introducida o su asociación con las personas indicadas." />');
					}
					panelEdicionExtendido.container.unmask();
					page.fireEvent(app.event.DONE);
					vaciarFormulario();
			    },
			    failure: function(form, action) {
			    	panelEdicionExtendido.container.unmask();
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
		}
	};

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : _handler
	});

	var recorrerPersonasStore = function() {
		var i=0;
		var auxId;
		for (i=0;i < personasStore.getCount();i++) {
			auxId = personasStore.getAt(i).data.id;
			listaIdPersonas.setValue(listaIdPersonas.getValue() + auxId + ',');
		}
	}
	
	var vaciarFormulario = function() {
		panelEdicionExtendido.getForm().reset();
		provincia.reset();
		localidad.setDisabled(true);
		localidad.reset();
		tipoVia.reset();
		persona.reset();
		personasStore.removeAll();
		btnIncluir.setDisabled(true);
		btnExcluir.setDisabled(true);
		page.fireEvent(app.event.CANCEL);
		provincia.focus(); 
	}

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			vaciarFormulario();
		}
	});

	var panelEdicion = new Ext.form.FieldSet({
		title:'<s:message code="rec-web.direccion.form.datosDireccion" text="**Datos de la dirección" />'
		,defaults : {cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
		,border : true
		,height : 200
        ,layout : 'table'
        ,autoWidth : true
		//,width:panelWidth
		,items : [
			{   layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,defaults : {xtype : 'fieldset', height:200, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:1px'}
				,items:[{items: [ provincia,codigoPostal,localidad,municipio,tipoVia,domicilio]}
						,{items: [ numero,portal,piso,escalera,puerta,origen]}
				]
			},
			{ xtype : 'errorList', id:'errL' }			
		]
	});	

	var panelEdicionAux = new Ext.form.FieldSet({
		title:'<s:message code="rec-web.direccion.form.datosDireccionAux" text="**Datos auxiliares de la dirección" />'
		,defaults : {cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
		,border : true
		,height : 160
        ,layout : 'table'
        ,autoWidth : true
		//,width:panelWidth
		,items : [
			{   layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,defaults : {xtype : 'fieldset', height:200, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:1px'}
				,items:[{items: [ comboOrigen,comboTipo,comboMotivo,comboEstado]}
						,{items: [ comboPrioridad,chkConsentimiento,observaciones]}
				]
			},
			{ xtype : 'errorList', id:'errL' }			
		]
	});	
var listaIdPersonas = new Ext.form.TextField({hidden:true,value:'', name:'listaIdPersonas'});

var idPersona = app.creaText("idPersona","Id Persona","",{
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
        flow:'direccion/getPersonasInstant'
        ,remoteSort:false
        ,autoLoad: false
        ,reader : new Ext.data.JsonReader({
            root:'data'
            ,fields:['idPersona','dniPersona','nombrePersona','personaCompleto']
        })
    });    
    
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

	var panelEdicionPersonas = new Ext.form.FieldSet({
		height: 200
        ,title:'<s:message code="rec-web.direccion.form.personasAsociadas" text="**Personas asociadas a la dirección" />'
        ,defaults : {layout:'form',border: false,bodyStyle:'padding:0px'} 
		,border : true
		,autoWidth : true
		//,width:panelWidth
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
	
	var panelEdicionExtendido = new Ext.form.FormPanel({
		autoHeight : true
		,autoWidth : true
        ,defaults : {layout:'form',border: false,bodyStyle:'padding-top:10px'} 
		,border : true
		//,width:panelWidth
		,items : [
			{   autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:1}
				,border:false
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
				,items:[{items: [ panelEdicion, panelEdicionAux, panelEdicionPersonas ]}]
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	

	page.add(panelEdicionExtendido);
	
</fwk:page>	