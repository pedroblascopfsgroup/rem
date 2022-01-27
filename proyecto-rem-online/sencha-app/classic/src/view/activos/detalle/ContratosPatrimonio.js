Ext.define('HreRem.view.activos.detalle.ContratosPatrimonio', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'contratospatrimonio',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'contratospatrimonio',
    scrollable	: 'y', 

	recordName: 'contrato',
	
	recordClass: "HreRem.model.ContratosPatrimonioModel",
    
    requires: ['HreRem.model.ContratosPatrimonioModel'],
    listeners: {
    	boxready: function() {
    		var me = this;
    		me.lookupController().cargarTabData(me);
    	}
    },
    
    initComponent: function () {

        var me = this;

        var items= [
			{   
				xtype:'fieldsettable', //BLOQUE ESTADO DE ARRENDAMIENTO
				//defaultType : 'displayfieldbase',
		        title: HreRem.i18n('title.fieldset.contrato.estado.patrimonio'),
				layout : {
					type : 'table',
					columns : 1
				},
				items :
					[	{
							xtype: 'displayfieldbase',
							bind: {hidden: '{!contrato.multiplesResultados}', value: HreRem.i18n('msg.error.informacion.duplicada')},
		                	fieldStyle: 'color:#ff0000; padding-top: 4px; text-align:right; font-weight: bold; font-size: 12px',
							readOnly: true
						},
						{
							xtype:'fieldset',
							defaultType: 'textfieldbase',
							layout : {
								type : 'table',
								columns : 3
							},
							items : 
								[
									{ //Fecha última actualización
										xtype:'datefieldbase',
										formatter: 'date("d/m/Y")',
										fieldLabel : HreRem.i18n('fieldlabel.fecha.ultima.actualizacion'),
										bind : '{contrato.fechaCreacion}',
										readOnly : true
									},
									{
										//Espacio en blanco
									},
									{
										//Espacio en blanco
									},
									{ //Número de contrato
										xtype : 'displayfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.numero.contrato.alquiler'),
										bind : '{contrato.idContrato}',
										readOnly : true
										
									},
									{ //Número de contrato antiguo
										xtype : 'displayfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.numero.contrato.alquiler.antiguo'),
										bind: {
												hidden : '{!contrato.esDivarian}',
												value: '{contrato.idContratoAntiguo}'
											},
										readOnly : true
										
									},
									{ 
										//Inquilino
										xtype : 'displayfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.patrimonio.contrato.inquilino'),
										bind : '{contrato.inquilino}',
										readOnly : true
									},
									{ 	//Renta

										xtype : 'displayfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.renta.contrato'),
										bind : '{contrato.cuota}',
										readOnly : true
									},
									{ //Fecha firma
										xtype: 'datefieldbase',
										formatter: 'date("d/m/Y")',
										fieldLabel : HreRem.i18n('fieldlabel.fecha.firma'),
										bind : '{contrato.fechaFirma}',
										readOnly : true
									},
									{ //Fecha de finalización del contrato
										xtype: 'datefieldbase',
										formatter: 'date("d/m/Y")',
										fieldLabel : HreRem.i18n('title.fieldset.contrato.finalizacion'),
										bind : '{contrato.fechaFinContrato}',
										readOnly : true
									},
									{ //Estado del contrato
										xtype : 'displayfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.estado.contrato'),
										bind : '{contrato.estadoContrato}',
										readOnly : true
									},
									{
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.suborigen.contrato'),
										reference: 'cesionDeUsoRef',
										bind: {
											readOnly: true,
											store: '{comboSuborigenContrato}',
											value: '{contrato.suborigenContrato}',
											rawValue: '{contrato.suborigenContratoDescripcion}',
											hidden: '{!isCarteraCajamarYUnicaja}'
										}
									},
									{
										xtype:'datefieldbase',
										formatter: 'date("d/m/Y")',
										fieldLabel : HreRem.i18n('fieldlabel.obligado.cumplimiento'),
										bind : {
											value: '{contrato.fechaObligadoCumplimiento}',
											hidden: '{!isCarteraCajamarYUnicaja}'
											},
										readOnly : true
										
									},
									{
										xtype : 'currencyfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.fianza.obligatoria'),
										bind: {
											value: '{contrato.fianzaObligatoria}',
											hidden: '{!isCarteraCajamarYUnicaja}'
										}
									},
									{
										xtype:'datefieldbase',
										formatter: 'date("d/m/Y")',
										fieldLabel : HreRem.i18n('fieldlabel.fecha.registro.aval.bancario'),
										bind : {
											value: '{contrato.fechaAvalBancario}',
											hidden: '{!isCarteraCajamarYUnicaja}'
											},
										readOnly : true
									},
									{
										xtype : 'currencyfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.importe.aval.bancario'),
										bind: {
											value: '{contrato.importeAvalBancario}',
											hidden: '{!isCarteraCajamarYUnicaja}'
										}
									},
									{
										xtype : 'currencyfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.importe.deposito.bancario'),
										colspan: 1,
										bind: {
											value: '{contrato.importeDepositoBancario}',
											hidden: '{!isCarteraCajamarYUnicaja}'
										}
									},
									{ //Oferta REM
										xtype : 'displayfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.oferta.REM'),
										bind: {
			                            	value: '<div style="color: #26607c">' + '{contrato.ofertaREM}' + '</div>'
			                            },
			                            colspan : 2,
			                            style: 'background: transparent; border: none;',
			                            handleMouseEvents: true,
										listeners: {
			   								'render': function() {
			   									this.getEl().on('mousedown', 'onEnlaceAbrirOferta');
			   									new Ext.tip.ToolTip({
			    								target: this.getEl(),
			    								html: HreRem.i18n('fieldlabel.numero.oferta.click')
												});
			   								}
										},
										readOnly : true
									},
									{
										//Espacio en blanco

									},
									{
										//Espacio en blanco
									}
								]
						},
						{
							layout : {
								type : 'table',
								columns : 2
							},
							items : 
								[
									{ //BLOQUE DEUDA ACTUAL
										xtype : 'fieldset',
										title: HreRem.i18n('title.patrimonio.contrato.deuda.actual'),
										height : 350,
										width : 350,
										margin : '0 10 10 0',
										layout : {
											type : 'table',
											columns : 1
										},
										defaultType : 'displayfieldbase',
										items : [
											{
												xtype : 'displayfieldbase',
												fieldLabel : HreRem.i18n('title.patrimonio.contrato.deuda.actual'),
												bind : '{contrato.deudaPendiente}',
												readOnly : true
											},
											{
												xtype : 'displayfieldbase',
												fieldLabel : HreRem.i18n('title.fieldlabel.patrimonio.contrato.recibos.adeudados'),
												bind : '{contrato.recibosPendientes}',
												readOnly : true
											},
											{
			
												xtype: 'datefieldbase',
												formatter: 'date("d/m/Y")',
												fieldLabel : HreRem.i18n('title.fieldlabel.patrimonio.fecha.ultimo.recibo.adeudado'),
												bind : '{contrato.ultimoReciboAdeudado}',
												readOnly : true
											},
											{
			
												xtype: 'datefieldbase',
												formatter: 'date("d/m/Y")',
												fieldLabel : HreRem.i18n('title.fieldlabel.patrimonio.fecha.ultimo.recibo.pagado'),
												bind : '{contrato.ultimoReciboPagado}',
												readOnly : true
											
											}
										]
								},
								{ //BLOQUE ACTIVOS RELACIONADOS
									xtype:'fieldsettable',
									title: HreRem.i18n('title.patrimonio.contrato.activos.relacionados'),
									height : 350,
									collapsible: false,
									items : [{
										 xtype: 'gridBase',
										 height: 300,
										 bind: {
								                store: '{storeActivosAsociados}'
								         },
										 colspan: 3,
										 columns: 
											 [{	  
									            text: HreRem.i18n('header.patrimonio.contrato.id.haya'),				            
									            dataIndex: 'numeroActivoHaya',
									            flex: 1
											  },
											  {
												  text: HreRem.i18n('header.patrimonio.contrato.direccion'),
												  dataIndex: 'localizacion',
												  flex: 1
										      },
										      {    
										    	  text: HreRem.i18n('header.patrimonio.contrato.tipologia'),
										    	  dataIndex: 'descripcion',
										    	  flex: 1
										      }
										    ],
										    dockedItems : [{
										    	xtype: 'pagingtoolbar',
									            dock: 'bottom',
									            itemId: 'activosAsociadosPaginationToolbar',
									            displayInfo: true,
									            bind: {
									                store: '{storeActivosAsociados}'
									            }
										    }
										 ]
									}]
								}
							]
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
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
		me.lookupController().cargarTabData(me);
		
    },
    
    actualizarCoordenadas: function(latitud, longitud) {
    	var me = this;
    	
    	me.getBindRecord().set("longitud", longitud);
    	me.getBindRecord().set("latitud", latitud);
    	
    }
});