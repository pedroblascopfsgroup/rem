Ext.define('HreRem.view.activos.detalle.DistribucionPlantasActivoList', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'distribucionplantasactivolist',
	topBar		: true,
	idPrincipal : 'activo.id',
	scrollable	: 'y',
	requires: ['HreRem.view.activos.detalle.AnyadirNuevaDistribucionActivo'],
	minHeight: 20,	
	
	features: [{
        ftype: 'grouping',
        groupHeaderTpl: '{[(values.rows[0].data.numPlanta == undefined || values.rows[0].data.numPlanta == null) ? "Sin definir" : values.rows[0].data.numPlanta == -1 ? "Planta " + values.rows[0].data.numPlanta : values.rows[0].data.numPlanta == 0 ? "Planta Baja" : values.rows[0].data.numPlanta + "&ordf; Planta"]} ({rows.length} estancia{[values.rows.length > 1 ? "s" : ""]})',
        hideGroupedHeader: true,
        startCollapsed: true,
        enableGroupingMenu: false,
        id: 'distribucionGrouping'
    }],
    listeners: {
	    groupclick: function (view, node, group, e, eOpts) {
	    	view.getSelectionModel().deselectAll();  
	    },
    	boxready: function(){
    		var me = this;
            me.setStore(Ext.create('Ext.data.Store',{
            	model: 'HreRem.model.Distribuciones',
    			 proxy: {
    			    type: 'uxproxy',
    				remoteUrl: 'activo/getListDistribucionesById',
    				extraParams: {id: me.lookupViewModel('activodetalle').get('activo.id')}
    			 },
    			 groupField: 'numPlanta',
    			 listeners:{
    		          load:function(){
    		        	  	me.relayEvents(this,['storeloadsuccess']);
    		               this.fireEvent('storeloadsuccess');
    		          }
    		     }
                
           }).load());
    	},
    	storeloadsuccess: function() {
            this.view.getFeature('distribucionGrouping').startCollapsed = true;
       }
    },			

    initComponent: function () {
        
        var me = this; 
        
        me.columns= [
        
				{   
					width: 150
				},
				{   text: HreRem.i18n('header.estancia'),
					dataIndex: 'tipoHabitaculoDescripcion',
					flex:2
				},
				{   text: HreRem.i18n('header.cantidad'),
					dataIndex: 'cantidad',
					flex:1,
					editor: {
						xtype:'numberfield', 
		        		hideTrigger: true,
		        		keyNavEnable: false,
		        		mouseWheelEnable: false
					}
				},	
				{   text: HreRem.i18n('header.superficie'), 
					renderer: Ext.util.Format.numberRenderer('0,000.00'),														        	
					dataIndex: 'superficie',
					flex:1,
					editor: {
						xtype:'numberfield', 
		        		hideTrigger: true,
		        		keyNavEnable: false,
		        		mouseWheelEnable: false
					}
				}     
		        
        ];         		
        me.callParent();      
    },
    

    onAddClick: function (btn) {
		var me = this;
		var activo = me.lookupController().getViewModel().get('activo'),
		numActivo= activo.get('numActivo');
		
		var ventana = Ext.create('HreRem.view.activos.detalle.AnyadirNuevaDistribucionActivo', {gridDistribuciones: me, activo: activo});
		ventana.getViewModel().set("activo", activo);
    	var form = ventana.down('formBase');
		me.up('activosdetallemain').add(ventana);
		ventana.show();
	    				    	
	},
	
	onDeleteClick: function(btn){
    	
    	var me = this;
        Ext.Msg.show({
        	   title: HreRem.i18n('title.confirmar.borrado.distribucion.vivienda'),
			   msg: HreRem.i18n('msg.confirmar.borrado.distribucion.vivienda'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	me.mask(HreRem.i18n("msg.mask.espere"));
			    		me.rowEditing.cancelEdit();
			            var sm = me.getSelectionModel();
			            sm.getSelection()[0].erase({
			            	success: function (a, operation, c) {
                                me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
								me.unmask();
								me.deleteSuccessFn();
                            },
                            
                            failure: function (a, operation) {
                            	var data = {};
                            	try {
                            		data = Ext.decode(operation._response.responseText);
                            	}
                            	catch (e){ };
                            	if (!Ext.isEmpty(data.msg)) {
                            		me.fireEvent("errorToast", data.msg);
                            	} else {
                            		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                            	}
								me.unmask();
								me.deleteFailureFn();
                            }
                        }
			            	
			            	
			            );
			            if (me.getStore().getCount() > 0) {
			                sm.select(0);
			            }
			        }
			   }
		});

    }

})