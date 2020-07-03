Ext.define('HreRem.view.activos.detalle.AgendaRevisionTituloGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'agendaRevisionTituloGrid',
	topBar		: true,
	addButton	: true,
	requires	: ['HreRem.model.AgendaRevisionTituloGridModel', 'HreRem.view.activos.detalle.VentanaCrearAgendaRevisionTitulo'],
	reference	: 'agendaRevisionTituloGridRef',
	editOnSelect: true,
	bind: { 
		store: '{storeAgendaRevisionTitulo}'
	},
	
    initComponent: function () {


     	var me = this;
        me.topBar = ($AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']));
        me.editOnSelect = ($AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']));

     	me.setTitle(HreRem.i18n('fieldlabel.grid.agenda.revision.titulo'));
     	
		me.columns = [
				{ 
		    		dataIndex: 'id',
		    		reference: 'id',
		    		name: 'idActivoAgendaRevisionTitulo',
		    		hidden: true
	    		},
				{ 
		    		dataIndex: 'subtipologiaDescripcion',
		    		reference: 'subtipologia',
		    		name:'subtipologia',
		    		text: HreRem.i18n('fieldlabel.agenda.revision.titulo.subtipologia'),
		    		allowBlank: false,
		    		flex: 0.7,
		    		editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'subtipologias'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo',
    					allowBlank: false
					}
	    		},
		        {
		            dataIndex: 'observaciones',
		            reference: 'observaciones',
		            name:'observaciones',
		            text: HreRem.i18n('fieldlabel.agenda.revision.titulo.observaciones'),
		            flex: 0.7,
		            allowBlank: false,
		            editor: {
		        		xtype: 'textareafield',
    					allowBlank: false
		        	}
		    		
		    		
		        },
		        {
		            dataIndex: 'fechaAlta',
		            reference: 'fechaAlta',
		            formatter: 'date("d/m/Y")',
		            name:'fechaAlta',
		            text: HreRem.i18n('fieldlabel.agenda.revision.titulo.fecha.alta'),
		            flex: 0.7
		        },
		        {
		            dataIndex: 'gestorAlta',
		            reference: 'gestorAlta',
		            name:'gestorAlta',
		            text: HreRem.i18n('fieldlabel.agenda.revision.titulo.gestor.alta'),
		            flex: 0.7	
		        }
		    ];

		    me.callParent();
    },
    
 
    onAddClick: function(btn){
    	var me = this;
    	var idActivo = me.lookupController().getView().getViewModel().get("activo.id");
		var grid = me;

		Ext.create("HreRem.view.activos.detalle.VentanaCrearAgendaRevisionTitulo", {entidad: 'agendatitulo', idEntidad: idActivo, parent:grid}).show();

    }, 
    onDeleteClick: function(){
    	var me = this;
    	var selection =  me.getSelection();
    	var grid = me;
    	
    	if(selection.length == 0){
    		me.fireEvent("errorToast", HreRem.i18n("msg.agenda.revision.titulo.eliminar.no.seleccionado")); 
    		return;
    	}
    	
    	var idActivoAgendaRevisionTitulo = me.getSelection()[0].getData().idActivoAgendaRevisionTitulo;
    	Ext.Msg.show({
			   title: HreRem.i18n('title.mensaje.confirmacion'),
			   msg: HreRem.i18n('msg.agenda.revision.titulo.eliminar'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	grid.mask(HreRem.i18n("msg.mask.loading"));
			        	var url = $AC.getRemoteUrl('admision/deleteAgendaRevisionTitulo');
		    			Ext.Ajax.request({
		    	    		url: url,
		    	    		method : 'GET',
		    	    		params: {
		    	    			idActivoAgendaRevisionTitulo:idActivoAgendaRevisionTitulo
		    	    		},
		    	    		
		    	    		success: function(response, opts){
		    	    			grid.getStore().load();
		    	    			me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok")); 
		    	    			grid.unmask();
		    	    		},
		    			 	failure: function(record, operation) {
		    			 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		    			 		grid.unmask();
		    			    },
		    			    callback: function(record, operation) {
		    			    	grid.unmask();
		    			    }
		    	    	});
			        }
			   }
		});

    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load(grid.loadCallbackFunction);
  		});
    }
});
