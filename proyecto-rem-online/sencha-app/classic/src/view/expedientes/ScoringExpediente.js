Ext.define('HreRem.view.expedientes.ScoringExpediente', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'scoringexpediente',    
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    disableValidation: true,
    reference	: 'scoringexpediente',
    scrollable	: 'y',
	recordName	: "scoring",
	
	recordClass	: "HreRem.model.ExpedienteScoring",
    
    requires	: ['HreRem.model.ExpedienteScoring', 'HreRem.model.HistoricoExpedienteScoring'],
    
    listeners: {
    	boxready: function() {
    		var me = this;
    		me.lookupController().cargarTabData(me);
    	}
    },
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.scoring'));
        var items= [

			{   
				xtype:'fieldsettable',
				title: HreRem.i18n('fieldlabel.bloque.detalle'),
				items :
					[
		                { 
		                	xtype:'textfieldbase',
							fieldLabel:HreRem.i18n('fieldlabel.estadoScoring'),
							cls: 'cabecera-info-field',
							readOnly: true,
							bind :'{scoring.comboEstadoScoring}',
				        	listeners: {
				        		change: 'onDisableMotivoRechazo'
				        	}
		                },
		                { 
							xtype: 'textfieldbase',
		                	fieldLabel:HreRem.i18n('fieldlabel.motivo.rechazo'),
				        	readOnly: true,
				        	disabled: false,
				        	reference:'scoringMotivoRechazo',
				        	bind : '{scoring.motivoRechazo}' 
				        },
				        { 
							xtype: 'textfieldbase',
		                	fieldLabel: HreRem.i18n('fieldlabel.numero.solicitud'),
				        	readOnly: true,
				        	bind : '{scoring.nSolicitud}'
				        },
				        { 
							xtype: 'checkboxfieldbase',
		                	name : HreRem.i18n('fieldlabel.revision'),
		                	fieldLabel: HreRem.i18n('fieldlabel.revision'),
                            reference: 'scoringCheckEnRevision',
				        	readOnly: false,
				        	disabled: false,
				        	bind : '{scoring.revision}',
				        	listeners: {
				        		change: 'onChangeRevision'
				        	}
				        },
				        { 
							xtype: 'textareafieldbase',
		                	fieldLabel: HreRem.i18n('fieldlabel.comentario'),
				        	disabled: true,
				        	reference:'scoringComentarios',
				        	bind:{
				        		value:  '{scoring.comentarios}'
	     					},	
	                        maxWidth: 500,
	                        maxLength: 200
				        }
					]
           },
           {   
				xtype:'fieldset',
				defaultType: 'textfieldbase',				
				title: HreRem.i18n('title.bloque.historico.scoring'),
				bind: {
					hidden: '{sinContraoferta}'
			    },
				items :
					[
						{   
				        	   xtype: 'gridBaseEditableRow',
				               idPrincipal: 'id',
				               cls: 'panel-base shadow-panel',
				               reference: 'gridHistorico',
				               bind: {
				            	   store: '{storeHistoricoScoring}'  
				               },
							   columns :
								[									
	        			    		{   
					                	text: HreRem.i18n('fieldlabel.fecha.sancion'),
							        	dataIndex: 'fechaSancion',
				                        flex: 1,
				                        formatter: 'date("d/m/Y")'
							        },
							       
									{ 
							        	text: HreRem.i18n('fieldlabel.resultado'),
					                	dataIndex: 'resultadoScoring',
				                        flex: 1
							        },
							        { 
							        	text:HreRem.i18n('fieldlabel.numero.solicitud'),
					                	dataIndex: 'nSolicitud',
				                        flex: 1
							        },
							        /*{	
							            text:HreRem.i18n('fieldlabel.documento.scoring'),
							            dataIndex: 'docScoring',
							            flex: 1
							        },*/
							        { 
					                	text:HreRem.i18n('fieldlabel.meses.fianza'),
					                	dataIndex: 'nMesesFianza',
				                        flex: 1
							        	
							        },
							        { 
					                	text:HreRem.i18n('fieldlabel.importe.fianza'),
					                	dataIndex: 'importeFianza',
				                        flex: 1
							        }
								]
				           },{
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            itemId: 'activosPaginationToolbar',
					            inputItemWidth: 60,
					            displayInfo: true,
					            bind: {
					                store: '{storeHistoricoScoring}'
					            }
					        }
					]
		    
           }
           
    	];
        
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
});