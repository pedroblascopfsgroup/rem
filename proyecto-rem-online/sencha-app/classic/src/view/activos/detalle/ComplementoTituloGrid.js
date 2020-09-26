Ext.define('HreRem.view.activos.detalle.ComplementoTituloGrid', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'complementotitulogrid',
    reference	: 'complementotitulogridref',
    topBar		: true,
    addButton	: true,
    requires	: ['HreRem.model.ActivoComplementoTituloModel', 'HreRem.view.activos.detalle.AnyadirComplementoTitulo'],
   // idActivo : null,
    editOnSelect: true,
    
    controller: 'activodetalle',
    viewModel: {
       type: 'activodetalle'
    },

    bind : {
    	store : '{storeComplementoTitulo}'
    },	
    initComponent: function () {
    	
    	var me = this;
     	
     	me.deleteSuccessFn = function(){
    		this.getStore().load()
    		this.setSelection(0);
    	};
     	
     	me.deleteFailureFn = function(){
    		this.getStore().load()
    	};
    	
    	me.topBar = ($AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['GESTORIA_ADMISION']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']));
    	me.editOnSelect = ($AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['GESTORIA_ADMISION']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']));
		
        me.columns = [
        		{
                    text : 'activoid',
                    dataIndex : 'activoId',
                    hidden: true,
                    flex : 1
                 },{
                    text : 'ID',
                    dataIndex : 'id',
                    hidden: true,
                    flex : 1
                 },{
                    text : HreRem.i18n('header.complemento.titulo.fecha.alta'),
                    dataIndex : 'fechaAlta',
                    flex : 1,
					formatter: 'date("d/m/Y")',
					readOnly: true
                 }, {
                    text : HreRem.i18n('header.complemento.titulo.gestor.alta'),
                    dataIndex : 'gestorAlta',
                    flex : 1,
                    readOnly: true
                 }, {
                    text : HreRem.i18n('header.complemento.titulo.tipo'),
                    flex : 1,
                    dataIndex : 'tipoTitulo',
                    editor: {		        		
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'tipoTituloComplemento'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo',
    					allowBlank: false					
		        	}
                 }, {
                	text : HreRem.i18n('header.complemento.titulo.fecha.solicitud'),
                    flex : 1,
                    dataIndex : 'fechaSolicitud',
					formatter: 'date("d/m/Y")',
					editor: {
		        		xtype: 'datefield'
		        	}
                 }, {
                    text : HreRem.i18n('header.complemento.titulo.fecha'),
                    flex : 1,
                    dataIndex : 'fechaTitulo',
					formatter: 'date("d/m/Y")',
					editor: {
		        		xtype: 'datefield'					
		        	}
                 }, {
                    text : HreRem.i18n('header.complemento.titulo.fecha.recepcion'),
                    flex : 1,
                    dataIndex : 'fechaRecepcion',
					formatter: 'date("d/m/Y")',
					editor: {
		        		xtype: 'datefield'
		        	}
                 }, {
                    text : HreRem.i18n('header.complemento.titulo.fecha.inscripcion'),
                    flex : 1,
                    dataIndex : 'fechaInscripcion',
					formatter: 'date("d/m/Y")',
					editor: {
		        		xtype: 'datefield'
		        	}
                 }, {
                    text : HreRem.i18n('header.complemento.titulo.observaciones'),
                    flex : 1,
                    dataIndex : 'observaciones',
                    editor: {
		        		xtype: 'textareafield'
		        	}
                 }

        ];        
        me.callParent();

        
    },
    
    onAddClick: function(btn){
		
		var me = this;	
		var idActivo = me.lookupController().getViewModel().data.idActivo;
 		Ext.create("HreRem.view.activos.detalle.AnyadirComplementoTitulo", {idActivo: idActivo}).show();

   },
    
    editFuncion: function(editor, context){
 		var me= this;
 		var id = context.record.data.id;
		var activoId = context.record.data.activoId;
		me.mask(HreRem.i18n("msg.mask.espere"));
		
		
			if (me.isValidRecord(context.record) ) {		

			
      		context.record.save({
      				
                  params : {
							id: id, activoId: activoId
						},
                  success: function (a, operation, c) {

                      if (context.store.load) {
                      	context.store.load();
                      }
                      me.unmask();
                      me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));																			
						me.saveSuccessFn();											
                  },
                  
				failure: function (a, operation) {

                  	try {
                  		
                  		var response = Ext.JSON.decode(operation.getResponse().responseText)
                  		
                  	}catch(err) {}
                  	
                  	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msgError)) {
                  		me.fireEvent("errorToast", response.msgError);
                  	} else {
                  		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                  	}
                  	grid.getStore().load();
                  	me.up('saneamientoactivo').funcionRecargar();
					me.unmask();
						
                  }
               });                            
      		me.disablePagingToolBar(false);
      		me.getSelectionModel().deselectAll();
      		editor.isNew = false;
			}
      
   },
    
       onDeleteClick : function() {
		var me = this;
		var grid = me;
		
		var id = me.getSelection()[0].getData().id;
		var activoId = me.getSelection()[0].getData().activoId;
		Ext.Msg.show({
			title : HreRem.i18n('title.mensaje.confirmacion'),
			msg : HreRem.i18n('msg.desea.eliminar'),
			buttons : Ext.MessageBox.YESNO,
			fn : function(buttonId) {
				if (buttonId == 'yes') {
					grid.mask(HreRem.i18n("msg.mask.loading"));
					var url = $AC.getRemoteUrl('activo/deleteActivoComplementoTitulo');
					Ext.Ajax.request({
						url : url,
						method : 'POST',
						params : {
							id: id, activoId: activoId
						},

						success : function(response, opts) {
							grid.getStore().load();
							me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
							grid.unmask();
							
						},
						failure : function(record, operation) {
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
							grid.unmask();
						},
						callback : function(record, operation) {
							grid.unmask();
						}
					});
				}
			}
		});

	}

});