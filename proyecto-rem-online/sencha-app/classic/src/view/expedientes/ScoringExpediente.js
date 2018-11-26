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
				        	disabled: true,
				        	reference:'scoringMotivoRechazo',
				        	bind : '{scoring.motivoRechazo}' 
				        },
				        { 
							xtype: 'textfieldbase',
		                	fieldLabel: HreRem.i18n('fieldlabel.numero.solicitud'),
				        	readOnly: false,
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
				        	readOnly: true,
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
				               bind: {
				            	   store: '{storeHistoricoScoring}'  
				               },
							   columns :
								[
									{
	        					        xtype: 'actioncolumn',
	        					        width: 30,	
	        					        hidden: '{tieneIdActivo}',
	        					        hideable: '{hideableTieneIdActivo}',
	        					        items: [{
	        					           	iconCls: 'ico-download',
	        					           	tooltip: HreRem.i18n("tooltip.download"),
	        					            handler: function(grid, rowIndex, colIndex) {
	        					                var record = grid.getRecord(rowIndex);
	        					                var idActivo=record.get("idActivo");
	        					                if(!Ext.isEmpty(idActivo)){
		        					               //Todo lo que viene a continuación, es para descargar el fichero
		        					                config = {};
													config.url=$AC.getWebPath()+"activo/bajarAdjuntoActivo."+$AC.getUrlPattern();
													config.params = {};
													config.params.id=record.get('identificador');
													config.params.idActivo=record.get("idActivo");
													config.params.nombreDocumento=record.get("docScoring"); 
													
													config = config || {};
			    
												    var url = config.url,
												        method = config.method || 'GET',// Either GET or POST. Default is POST.
												        params = config.params || {};
												    var form = Ext.create('Ext.form.Panel', {
												        standardSubmit: true,
												        url: url,
												        method: method
												    });
												    form.submit({
												        target: '_blank', 
												        params: params
												    });
												    Ext.defer(function(){
												        form.destroy();
												    }, 1000);
	        					                 				                
	        					                }else{
	        					                	me.fireEvent("errorToast", "No hay adjunto ningun documento de tipo Scoring");
	        					                }
	        					            }
	        					        }]
	        			    		},
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
							        {	
							            text:HreRem.i18n('fieldlabel.documento.scoring'),
							            dataIndex: 'docScoring',
							            flex: 1
							        },
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
    	
    }
});