Ext.define('HreRem.view.activos.detalle.TributosGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'tributosgrid',
	topBar		: true,
	targetGrid	: 'tributosGrid',
	idPrincipal : 'activo.id',
	editOnSelect: true,
    bind: {
        store: '{storeActivoTributos}'
    },

    listeners: {
		rowclick: 'onTributoClick',
		deselect: 'deselectTributo'
    },
    
    initComponent: function () {
    	
     	var me = this;
     	
    	me.features = [{
    		id: 'summary',
    		ftype: 'summary',
   			hideGroupedHeader: true,
    		enableGroupingMenu: false,
    		dock: 'bottom'
		}];
		

		me.columns = [
			{   text: 'id',
	        	dataIndex: 'idTributo',
	        	hidden: true,
	        	hideable: false,
	        	flex: 1
	        },
	        {	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.tipo.tributo'),		            
	            dataIndex: 'tipoTributo',
	            flex: 1,
	            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
	            	var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboTipoTributo').findRecord('codigo', value);
	            	var descripcion;
	        		if(!Ext.isEmpty(foundedRecord)) {
	        			descripcion = foundedRecord.getData().descripcion;
	        		}
	            	return descripcion;
	        	},
        		editor: {
        			xtype: 'comboboxfieldbase',
					addUxReadOnlyEditFieldPlugin: false,
	        		   labelWidth: '25%',
			            width: '15%',
	            		allowBlank: false,
		        	
	        		bind: {
	            		store: '{comboTipoTributo}',
	            		value: '{tipoTributo}'
	            	},
	            	displayField: 'descripcion',
					valueField: 'codigo'
        		}
		   	},
	    	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.recepcion.tributo'),				            
	            dataIndex: 'fechaRecepcionTributo',
	            flex: 1,
	            formatter: 'date("d/m/Y")',
        		editor: {
               	 xtype: 'datefield',
             	 allowBlank: false
            	}
		   	},
		   	{
		   		text: HreRem.i18n('fieldlabel.exento'),				            
	            dataIndex: 'estaExento',
	            flex: 1,
	            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
	            	var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboSinSino').findRecord('codigo', value);
	            	var descripcion;
	        		if(!Ext.isEmpty(foundedRecord)) {
	        			descripcion = foundedRecord.getData().descripcion;
	        		}
	            	return descripcion;
	        	},
        		editor: {
        			xtype: 'comboboxfieldbase',
					addUxReadOnlyEditFieldPlugin: false,
	        		   labelWidth: '25%',
			            width: '15%',
	            		allowBlank: false,
		        	
	        		bind: {
	            		store: '{comboSinSino}',
	            		value: '{estaExento}'
	            	},
	            	listeners: {
	            		change: function(chkBox, nVal, oVal){
	            			var chkBoxMotivoExento = chkBox.up('tributosgrid').down('[reference="motivoExentoRef"]');

	            			if(CONST.COMBO_SIN_SINO['SI'] === nVal){
	            				chkBoxMotivoExento.getEditor().allowBlank = false;
	            			}else{
	            				chkBoxMotivoExento.getEditor().allowBlank = true;
	            			}
	            			chkBox.up().isValid();
	            		}
	            	},
	            	displayField: 'descripcion',
					valueField: 'codigo'
        		}
		   	},
		   	{
		   		text: HreRem.i18n('fieldlabel.motivo.exento'),				            
	            dataIndex: 'motivoExento',
	            reference: 'motivoExentoRef',
	            flex: 1,
	            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
	            	var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboMotivoExento').findRecord('codigo', value);
	            	var descripcion;
	        		if(!Ext.isEmpty(foundedRecord)) {
	        			descripcion = foundedRecord.getData().descripcion;
	        		}
	            	return descripcion;
	        	},
        		editor: {
        			xtype: 'comboboxfieldbase',
					addUxReadOnlyEditFieldPlugin: false,
	        		labelWidth: '25%',
			        width: '15%',
			        allowBlank: true,
	        		bind: {
	            		store: '{comboMotivoExento}',
	            		value: '{motivoExento}'
	            	},
	            	displayField: 'descripcion',
					valueField: 'codigo'
        		}
		   	},
			{
	            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.pago.tributo'),
	            reference: 'fechaPagoTributo',
	            dataIndex: 'fechaPagoTributo',
	            flex: 1,
	            formatter: 'date("d/m/Y")',
        		editor: {
        			xtype: 'datefield',
        			allowBlank: true
            	}
		   	},
		   	{
	            text: HreRem.i18n('fieldlabel.administracion.activo.importe.pagado.tributo'),
	            reference: 'importePagadoTributo',
	            dataIndex: 'importePagado',
	            //xtype: 'numbercolumn',  textfield  , numberfieldbase
	            flex: 1,
        		editor: {
    	            xtype: 'numberfield',
			        allowBlank: true,
    	            decimalPrecision: 2,
    	            hideTrigger: true,
    		        decimalSeparation: '.'
            	}
		   	},
				       	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.presentacion.recurso'),				            
	            dataIndex: 'fechaPresentacion',
	            flex: 1,
	            formatter: 'date("d/m/Y")',
        		editor: {
               	 xtype: 'datefield',
               	 allowBlank: false
            	}
		   	},
		   	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.recepcion.propietario'),				            
	            dataIndex: 'fechaRecPropietario',
	            flex: 1,
	            formatter: 'date("d/m/Y")',
        		editor: {
               	 xtype: 'datefield',
                 cls: 'grid-no-seleccionable-field-editor',
             	 allowBlank: true
            	}
		   	},
		   	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.recepcion.gestoria'),			            
	            dataIndex: 'fechaRecGestoria',
	            flex: 1,
	            formatter: 'date("d/m/Y")',
        		editor: {
               	 xtype: 'datefield',
               	 allowBlank: true
            	}
		   	},
		   	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.tipo.solicitud'),		            
	            dataIndex: 'tipoSolicitud',
	            flex: 1,
	            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
	            	var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboTipoSolicitud').findRecord('codigo', value);
	            	var descripcion;
	        		if(!Ext.isEmpty(foundedRecord)) {
	        			descripcion = foundedRecord.getData().descripcion;
	        		}
	            	return descripcion;
	        	},
        		editor: {
        			xtype: 'comboboxfieldbase',
					addUxReadOnlyEditFieldPlugin: false,
	        		   labelWidth: '25%',
			            width: '15%',
	            		allowBlank: false,
		        	
	        		bind: {
	            		store: '{comboTipoSolicitud}',
	            		value: '{tipoSolicitud}'
	            	},
	            	displayField: 'descripcion',
					valueField: 'codigo'
        		}
		   	},
		   	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.observaciones'),		            
	            dataIndex: 'observaciones',
	            flex: 1,
	            editor: {
		           xtype:'textarea'
		        }
		   	},
		   	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.recepcion.recurso.propietario'),		            
	            dataIndex: 'fechaRecRecursoPropietario',
	            flex: 1,
	            formatter: 'date("d/m/Y")',
        		editor: {
               	 xtype: 'datefield',
               	 allowBlank: true
            	}
		   	},
		   	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.recepcion.recurso.gestorias'),	            
	            dataIndex: 'fechaRecRecursoGestoria',
	            flex: 1,
	            formatter: 'date("d/m/Y")',
        		editor: {
               	 xtype: 'datefield',
               	 allowBlank: true
            	}
		   	},
		   	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.respuesta.recurso'),	            
	            dataIndex: 'fechaRespRecurso',
	            flex: 1,
	            formatter: 'date("d/m/Y")',
        		editor: {
               	 xtype: 'datefield',
               	 allowBlank: true
            	}
		   	},
		   	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.resultado.solicitud'),            
	            dataIndex: 'resultadoSolicitud',
	            flex: 1,
	            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
	            	var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboResultadoSolicitud').findRecord('codigo', value);
	            	var descripcion;
	        		if(!Ext.isEmpty(foundedRecord)) {
	        			descripcion = foundedRecord.getData().descripcion;
	        		}
	            	return descripcion;
	        	},
	            editor: {
	            	xtype: 'comboboxfieldbase',
					addUxReadOnlyEditFieldPlugin: false,
	        		   labelWidth: '25%',
			            width: '15%',
	            		allowBlank: true,
		        	
	        		bind: {
	            		store: '{comboResultadoSolicitud}',
	            		value: '{resultadoSolicitud}'
	            	},
	            	displayField: 'descripcion',
					valueField: 'codigo'
        		}
		   	},
		   	{
	            text: HreRem.i18n('fieldlabel.administracion.activo.num.gasto.vinculado'),
	            dataIndex: 'numGastoHaya',
	            flex: 1,
	            editor: {
   					xtype:'numberfield',
        			hideTrigger: true,
        			keyNavEnable: false,
        			mouseWheelEnable: false,
        			allowBlank: true,
        			listeners: {
        				blur: function() {
       						var me = this;
                			var fechaPagoTributo = me.up('tributosgrid').down('[reference="fechaPagoTributo"]');
                			var importePagadoTributo = me.up('tributosgrid').down('[reference="importePagadoTributo"]');

                			if(me.getValue() != null && me.getValue() !== "") {
                				fechaPagoTributo.getEditor().allowBlank = false;
                				importePagadoTributo.getEditor().allowBlank = false;
                			} else {
                				fechaPagoTributo.getEditor().allowBlank = true;
                				importePagadoTributo.getEditor().allowBlank = true;
                			}
            				me.up().isValid();
                		}
       				}
   				}
		   	},	{	  
	            text: 'ExisteDocumento',
	            reference: 'existeDocumentoTributo',
	            dataIndex: 'existeDocumentoTributo',
	            flex: 0.5,
	            editor: {
	        		xtype:'textarea',
	        		readOnly: true
        		}
		   	},
		   	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.num.expediente.vinculado.tributo'),           
	            dataIndex: 'numExpediente',
	            flex: 1,
	            editor: {
   					xtype:'numberfield', 
        			hideTrigger: true,
        			keyNavEnable: false,
        			mouseWheelEnable: false,
        			allowBlank: true
   				}
		   	},
		   	{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.comunicacion.devolucion.ingreso.tributo'),	            
	            dataIndex: 'fechaComunicacionDevolucionIngreso',
	            flex: 1,
	            formatter: 'date("d/m/Y")',
        		editor: {
               	 xtype: 'datefield',
               	 allowBlank: true
            	}
		   	},
			{	  
	            text: HreRem.i18n('fieldlabel.administracion.activo.importe.recuperado.recurso.tributo'),	
	            dataIndex: 'importeRecuperadoRecurso',
	            flex: 1,
        		editor: {
    	            xtype: 'numberfield',
    	            decimalPrecision: 2,
    	            hideTrigger: true,
    		        decimalSeparation: '.',
    	            allowBlank: true
            	}
		   	},
		   	{
		   		text: HreRem.i18n('fieldlabel.administracion.activo.numero.tributo'),
	            dataIndex: 'numTributo',
	            flex: 1,
	            readOnly: true
		   	}
		    ];
		

		    me.dockedItems = [
		        {
		        	xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            displayInfo: true,
		            bind: {
		                store: '{storeActivoTributos}'
		            }
		        }
		    ];
		    
		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.getStore().load();
		    	return true;
		    };

		    me.callParent();

   },
   
   funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
 			grid.getStore().load();
 		});
		me.lookupController().cargarTabData(me);
   }
   
});
