Ext.define('HreRem.view.activos.detalle.DatosBasicosActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosbasicosactivo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'datosbasicosactivo',
    scrollable	: 'y',

	recordName: "activo",
	
	recordClass: "HreRem.model.Activo",
    
    requires: ['HreRem.model.Activo'],
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.datos.basicos'));
        var items= [

			{   
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				
				title: HreRem.i18n('title.identificacion'),
				items :
					[
		                {
		                	xtype: 'displayfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.id.activo.haya'),
		                	bind:		'{activo.numActivo}'

		                },
						{ 
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.id.bien.recovery'),
							bind:		'{activo.idRecovery}'
						},
						{ 
		                	xtype: 'textareafieldbase',
		                	labelWidth: 200,
		                	rowspan: 4,
		                	height: 160,
		                	labelAlign: 'top',
		                	fieldLabel: HreRem.i18n('fieldlabel.breve.descripcion.activo'),
		                	bind:		'{activo.descripcion}'
		                },
						{
							xtype: 'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.id.activo.prinex'),
							bind:		'{activo.idProp}'
						},
						{ 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
							reference: 'tipoActivo',
				        	chainedStore: 'comboSubtipoActivo',
							chainedReference: 'subtipoActivoCombo',
				        	bind: {
			            		store: '{comboTipoActivo}',
			            		value: '{activo.tipoActivoCodigo}'
			            	},
    						listeners: {
			                	select: 'onChangeChainedCombo'
			            	},
			            	allowBlank: false
				        },
						{
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.id.activo.sareb'),
			                bind:		'{activo.idSareb}'
						},
						{ 
							xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
				        	reference: 'subtipoActivoCombo',
				        	bind: {
			            		store: '{comboSubtipoActivo}',
			            		value: '{activo.subtipoActivoCodigo}',
			            		disabled: '{!activo.tipoActivoCodigo}'
			            	},
    						allowBlank: false
				        },			       
						{ 
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.id.activo.uvem'),
		                	bind:		'{activo.numActivoUvem}'
		                },
						{ 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.estado.fisico.activo'),
				        	name: 'estadoActivoCodigo',
				        	bind: {
			            		store: '{comboEstadoActivo}',
			            		value: '{activo.estadoActivoCodigo}'
			            	}			
				        },	
		                { 
		                	xtype: 'displayfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.id.activo.rem'),
		                	bind:		'{activo.numActivoRem}'
		                },
		                {
		                	xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.uso.dominante'),
				        	name: 'tipoUsoDestinoCodigo',
		                	bind: {
			            		store: '{comboTipoUsoDestino}',
			            		value: '{activo.tipoUsoDestinoCodigo}'
			            	}
		                }
					]
           },
           
            {    
                
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.direccion'),
				items :
					[
						// fila 1
						{							
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.tipo.via'),
				        	bind: {
			            		store: '{comboTipoVia}',
			            		value: '{activo.tipoViaCodigo}'			            		
			            	},
    						allowBlank: false
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.provincia'),
							reference: 'provinciaCombo',
							chainedStore: 'comboMunicipio',
							chainedReference: 'municipioCombo',
			            	bind: {
			            		store: '{comboProvincia}',
			            	    value: '{activo.provinciaCodigo}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
    						},
    						allowBlank: false
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.latitud'),
							readOnly	: true,
							bind:		'{activo.latitud}'
		                },						
						// fila 2	
						
						{ 
							fieldLabel:  HreRem.i18n('fieldlabel.nombre.via'),
		                	bind:		'{activo.nombreVia}',
		                	allowBlank: false
		                },
		                {
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.municipio'),
							reference: 'municipioCombo',
							chainedStore: 'comboInferiorMunicipio',
							chainedReference: 'inferiorMunicipioCombo',
			            	bind: {
			            		store: '{comboMunicipio}',
			            		value: '{activo.municipioCodigo}',
			            		disabled: '{!activo.provinciaCodigo}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
    						},
    						allowBlank: false
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.longitud'),
							readOnly: true,
							bind:		'{activo.longitud}'
		                }, 
		                // fila 3               
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.numero'),
		                	bind:		'{activo.numeroDomicilio}'
		                },
		                {
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.unidad.poblacional'),
							reference: 'inferiorMunicipioCombo',
			            	bind: {
			            		store: '{comboInferiorMunicipio}',
			            		value: '{activo.inferiorMunicipioCodigo}',
			            		disabled: '{!activo.municipioCodigo}'
			            	},
			            	tpl: Ext.create('Ext.XTemplate',
			            		    '<tpl for=".">',
			            		        '<div class="x-boundlist-item">{descripcion}</div>',
			            		    '</tpl>'
			            	),
			            	displayTpl: new Ext.XTemplate(
			            	        '<tpl for=".">' +
			            	        '{[typeof values === "string" ? values : values["descripcion"]]}' +
			            	        '</tpl>'
			            	)
						},
						{
		                	xtype: 'button',
		                	reference: 'botonVerificarDireccion',
		                	disabled: true,
		                	bind:{
		                		disabled: '{!editing}'
		                	},
		                	rowspan: 2,
		                	text: HreRem.i18n('btn.verificar.direccion'),
		                	handler: 'onClickVerificarDireccion'
		                	
		                },	
		                // fila 4
		                {
							fieldLabel:  HreRem.i18n('fieldlabel.escalera'),
			                bind:		'{activo.escalera}'
						},
				        { 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.comunidad.autonoma'),
				        	forceSelection: true,
				        	readOnly: true,
				        	bind: {		
				        		store: '{storeComunidadesAutonomas}',
			            		value: '{activo.provinciaCodigo}'
			            	},
							valueField: 'id',
							allowBlank: false
								
					     },					
						 // fila 5
 						{ 
		                	fieldLabel:  HreRem.i18n('fieldlabel.planta'),
		                	bind:		'{activo.piso}'
		                },	               
		                {
							xtype: 'comboboxfieldbase',
							reference: 'pais',
							fieldLabel: HreRem.i18n('fieldlabel.pais'),
			            	bind: {
			            		store: '{comboPais}',
			            		value: '{activo.paisCodigo}'
			            	},
    						colspan: 2,
    						allowBlank: false
		                	
						},
						// fila 6
						 { 
		                	fieldLabel:  HreRem.i18n('fieldlabel.puerta'),
		                	bind:		'{activo.puerta}'
		                },
		                {
							fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
							bind:		'{activo.codPostal}',
							colspan: 2,
							vtype: 'codigoPostal',
							maskRe: /^\d*$/, 
		                	maxLength: 5,
							allowBlank: false		                	
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
    	
    },
    
    actualizarCoordenadas: function(latitud, longitud) {
    	var me = this;
    	
    	me.getBindRecord().set("longitud", longitud);
    	me.getBindRecord().set("latitud", latitud);
    	
    }
});