Ext.define('HreRem.view.trabajos.detalle.TarifasTrabajo', {
    extend: 'Ext.form.Panel',
    xtype: 'tarifastrabajo',
    layout: 'fit',
    
    initComponent: function () {
    	
    	var me = this;  
    	
    	me.items= [
    	
    				{
    					  
                
						xtype:'fieldsettable',
						defaultType: 'container',
						title: HreRem.i18n('title.lista.tarifas.trabajo'),
						layout: 'hbox',
						items :
								[
									{	
										defaults: {xtype: 'textfieldbase'},
										items: [
											{
												fieldlabel: HreRem.i18n("fieldlabel.proveedor")
											},
											{
												fieldlabel: HreRem.i18n("fieldlabel.propietario")
											},
											{
												fieldlabel: HreRem.i18n("fieldlabel.presupuesto")
											}
										]
									},
									{
										items: [
										
												{
												    xtype		: 'gridBaseEditableRow',
												    idPrincipal : 'trabajo.id',
												    topBar: true,
												    reference: 'listadoTarifas',
													cls	: 'panel-base shadow-panel',
													bind: {
														store: '{storeTarifas}'
													},
													columns: [
													   {    text: 'Tarifa',
												        	dataIndex: 'tarifa'
												       },
													   {
												            text: 'Tipo trabajo',
												            dataIndex: 'tipoTrabajo'
												            
												       },
												       {   
												       		text: 'Subtipo trabajo',
												       	    dataIndex: 'observacion'
												       },
												       {   
												       		text: 'Tipo tarifa',
												       	    dataIndex: 'tipoTarifa'
												       },
												       {   
												       		text: 'Precio unitario',
												       	    dataIndex: 'precioUnitario'
												       },
												       {   
												       		text: 'Medición',
												       	    dataIndex: 'medicion'
												       },
												       {   
												       		text: 'Importe total',
												       	    dataIndex: 'importeTotal'
												       }
												       	        
												    ],
												    dockedItems : [
												        {
												            xtype: 'pagingtoolbar',
												            dock: 'bottom',
												            displayInfo: true,
												            bind: {
												                store: '{storeTarifas}'
												            }
												        }
												    ]
												    
												}
										
										]
										
									}

								]
    				}
    	
    	
    	
    	];
    	
    	
    	me.callParent();
    	
    }

});