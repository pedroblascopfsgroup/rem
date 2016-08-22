Ext.define('HreRem.view.expedientes.DatosBasicosExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosbasicosexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'datosbasicosactivo',
    scrollable	: 'y',

	recordName: "expediente",
	
	recordClass: "HreRem.model.ExpedienteComercial",
    
    requires: ['HreRem.model.ExpedienteComercial'],
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.ficha'));
        var items= [

			{   
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',				
				title: HreRem.i18n('title.identificacion'),
				items :
					[
		                {
		                	xtype: 'displayfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.num.expediente'),
		                	bind:		'{expediente.numExpediente}'

		                },						
						{
							xtype: 'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.cartera'),
							bind:		'{expediente.entidadPropietariaDescripcion}'
						},						
						{
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.propietario'),
			                bind:		'{expediente.propietario}'
						},		       
						{ 
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
		                	bind:		'{expediente.tipoExpedienteDescripcion}'
		                },		                
		                { 
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fiedlabel.numero.activo.agrupacion'),
		                	bind:		'{expediente.numEntidad}'
		                }
						
					]
           },
           {    
                xtype:'fieldsettable',
				defaultType: 'displayfield',
				title: HreRem.i18n('title.tramite.expediente'),
				items: [
					{ 
						fieldLabel: HreRem.i18n('fieldlabel.fecha.alta.oferta'),
	                	bind:		'{expediente.fechaAltaOferta}',
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                },
	                {
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.aceptacion'),
	                	bind:		'{expediente.fechaAlta}',
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                },
	                {
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion'),
	                	bind:		'{expediente.fechaSancion}',
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                },
	                { 
						fieldLabel: HreRem.i18n('fieldlabel.fecha.reserva'),
	                	bind:		'{expediente.fechaReserva}',
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                },
	                {
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.posicionamiento'),
	                	bind:		'{expediente.fechaPosicionamiento}'	  ,
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                },
	                {
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.contabilizacion.propietario'),
	                	bind:		'{expediente.fechaContabilizacionPropietario}',
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                }

				]
				
				
           },
           {    
                xtype:'fieldsettable',
				defaultType: 'displayfield',
				title: HreRem.i18n('title.anulacion'),
				items: [
						{
							fieldLabel: HreRem.i18n('fieldlabel.fecha.anulacion'),
							bind: '{expediente.fechaAnulacion}',
							renderer: Ext.util.Format.dateRenderer('d-m-Y')
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.motivo.anulacion'),
							bind: '{expediente.motivoAnulacion}',
							colspan: 2
						},	
						{
							fieldLabel: HreRem.i18n('fieldlabel.peticionario'),
							bind: '{expediente.peticionario}'
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.fecha.devolucion.entregas.a.cuenta'),
							bind: '{expediente.fechaDevolucionEntregas}',
							renderer: Ext.util.Format.dateRenderer('d-m-Y')
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.importe.devolucion'),
							bind: '{expediente.importeDevolucion}'
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