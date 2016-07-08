Ext.define('HreRem.view.activos.detalle.TasacionesActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'tasacionesactivo',    
    scrollable	: 'y',

    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.tasaciones'));
        var items= [
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.ultima.tasacion'),
				items :	[
			   				{ 
			   					xtype: 'currencyfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.valor.ultima.tasacion'),
								width:		250,
								bind:		'{valoraciones.importeValorTasacion}',
			                	readOnly: true
							},
						    {
								xtype: 'datefieldbase',
								formatter: 'date("d/m/Y")',
								fieldLabel: HreRem.i18n('fieldlabel.fecha.ultima.tasacion'),
								width:		250,
								bind:		'{valoraciones.fechaValorTasacion}',
								readOnly: true
						    },
						    {
						    	xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.tipo.ultima.tasacion'),
								width:		250,
								bind:		'{valoraciones.tipoTasacionDescripcion}',
								readOnly: true
						    }
				]
            },
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.historico.tasaciones'),
				items :	[
							{
								xtype: 'gridBase',
			   					cls	: 'panel-base shadow-panel',
			   					bind: {
			   						store: '{storeTasaciones}'
			   					},
			   					colspan: 3,
			   					columns: [
			   					    {   text: HreRem.i18n('header.listado.tasacion.id'), 
			   				        	dataIndex: 'id',
			   				        	flex:1 
			   				        },
			   				        {   text: HreRem.i18n('header.listado.tasacion.tipoTasacion'),
			   				        	dataIndex: 'tipoTasacionDescripcion',
			   				        	flex:4
			   				        },	
			   				        {   
			   				        	text: HreRem.i18n('header.listado.tasacion.importe'),
			   				        	dataIndex: 'importeValorTasacion',
			   				        	renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	},
			   				        	flex:2 
			   				        },
			   				        {   
			   				        	text: HreRem.i18n('header.listado.tasacion.fechaFin'),
			   				        	dataIndex:	'fechaValorTasacion',
			   				        	flex:2
			   				        },
			   				        {   
			   				        	text: HreRem.i18n('header.listado.tasacion.nomTasadora'),
			   				        	dataIndex:	'nomTasador',
			   				        	flex:3
			   				        }    	        
			   				    ],
			   				    dockedItems : [
			   				        {
			   				            xtype: 'pagingtoolbar',
			   				            dock: 'bottom',
			   				            displayInfo: true,
			   				            bind: {
			   				                store: '{storeTasaciones}'
			   				            }
			   				        }
			   				    ],
			   				    listeners: [
			   				        {rowdblclick: 'onTasacionListDobleClick'}
			   					    
			   		    		]
							}
				
				]
            },           
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.detail.tasacion'),
				reference: 'detalleTasacion',
				items :	[
								     				        				    
					{ 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.fechaTasacion'),
						width:		250,
						bind:		'{tasacion.fechaInicioTasacion}',
						readOnly: true
					},
					{ 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.fechaSolTasacion'),
						width:		250,
						bind:		'{tasacion.fechaSolicitudTasacion}',
						readOnly: true
					},
					{ 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.fechaRecepcionTasacion'),
						width:		250,
						bind:		'{tasacion.fechaRecepcionTasacion}',
						readOnly: true
					},
					{ 
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.codFirmaTasadora'),
						width:		250,
						bind:		'{tasacion.codigoFirma}',
						readOnly: true
					},
					{ 
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.nomTasador'),
						width:		250,
						bind:		'{tasacion.nomTasador}',
						readOnly: true
					},
					{
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorTasacion'),
						width:		250,
						bind:		'{tasacion.importeValorTasacion}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeTasacionFin'),
						width:		250,
						bind:		'{tasacion.importeTasacionFin}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeRepoNetoActual'),
						width:		250,
						bind:		'{tasacion.costeRepoNetoActual}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeRepoNetoFin'),
						width:		250,
						bind:		'{tasacion.costeRepoNetoFinalizado}',
						readOnly: true
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.coefMercadoEstado'),
						width:		250,
						bind:		'{tasacion.coeficienteMercadoEstado}',
						readOnly: true
					},	       				     
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.coefMercadoEstadoHom'),
						width:		250,
						bind:		'',
						readOnly: true
					},
					{
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.coefPondValorAnadido'),
						width:		250,
						bind:		'{tasacion.coeficientePondValorAnanyadido}',
						readOnly: true
					},
					{ 
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.tipoTasacion'),
						width:		250,
						bind:		'{tasacion.tipoTasacionDescripcion}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.valorReperSueloConst'),
						width:		250,
						bind:		'{tasacion.valorReperSueloConst}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeConstConstruido'),
						width:		250,
						bind:		'{tasacion.costeConstConstruido}',
						readOnly: true
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.indiceDepreciacionFisica'),
						width:		250,
						bind:		'{tasacion.indiceDepreFisica}',
						readOnly: true
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.indiceDepreciacionFuncional'),
						width:		250,
						bind:		'{tasacion.indiceDepreFuncional}',
						readOnly: true
					},
					{ 
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.indiceTotalDepreciacion'),
						width:		250,
						bind:		'{tasacion.indiceTotalDepre}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeConstruccionDepreciada'),
						width:		250,
						bind:		'{tasacion.costeConstDepreciada}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeUnitarioRepoNeto'),
						width:		250,
						bind:		'{tasacion.costeUnitarioRepoNeto}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeReposicion'),
						width:		250,
						bind:		'{tasacion.costeReposicion}',
						readOnly: true
					},
					{ 
						xtype: 'numberfieldbase',
						symbol: HreRem.i18n("symbol.porcentaje"),
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.porcentajeObra'),
						width:		250,
						bind:		'{tasacion.porcentajeObra}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorTerminado'),
						width:		250,
						bind:		'{tasacion.importeValorTerminado}',
						readOnly: true
					},
					{ 
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.identifTextoAsociado'),
						width:		250,
						bind:		'{tasacion.idTextoAsociado}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorLegalFinca'),
						width:		250,
						bind:		'{tasacion.importeValorLegalFinca}',
						readOnly: true
					},
					{ 
						xtype: 'currencyfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorSolar'),
						width:		250,
						bind:		'{tasacion.importeValorSolar}',
						readOnly: true
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