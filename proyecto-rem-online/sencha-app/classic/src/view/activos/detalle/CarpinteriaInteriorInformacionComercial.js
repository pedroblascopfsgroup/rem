Ext.define('HreRem.view.activos.detalle.CarpinteriaInteriorInformacionComercial', {
    xtype: 'carpinteriainteriorinformacioncomercial',        
    reference: 'carpinteriainteriorref',
    extend: 'Ext.container.Container',       
    cls	: 'panel-base shadow-panel',
    flex: 1,
    scrollable: 'y',

    initComponent: function () {

        var me = this;
        me.items= [
			{    
				xtype:'fieldset',
			    collapsed: false,
			    layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 2,
			        trAttrs: {height: '30px', width: '100%'},
			        tdAttrs: {width: '50%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				defaultType: 'textfieldbase',        
				items : [
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.puerta.entrada.normal'),
							flex: 1,
							//Poner el label a la izquierda
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.puertaEntradaNormal}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.puerta.entrada.blindada'),
							flex: 1,
							//Poner el label a la izquierda
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.puertaEntradaBlindada}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.puerta.entrada.acorazada'),
							flex: 1,
							//Poner el label a la izquierda
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.puertaEntradaAcorazada}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.puertas.paso.macizas'),
							flex: 1,
							//Poner el label a la izquierda
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.puertaPasoMaciza}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.puertas.paso.huecas'),
							flex: 1,
							//Poner el label a la izquierda
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.puertaPasoHueca}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.puertas.paso.lacadas'),
							flex: 1,
							//Poner el label a la izquierda
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.puertaPasoLacada}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.armarios.empotrados'),
							flex: 1,
							//Poner el label a la izquierda
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.armariosEmpotrados}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.nivel.acabado.interior'),
							flex: 1,
							//Poner el label a la izquierda
							emptyDisplayText: '-',
							bind: {
								store: '{comboAcabadoCarpinteria}',
								value: '{infoComercial.acabadoCarpinteriaCodigo}'
							},
							readOnly: false
						},
						{
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.otros'),
							bind: '{infoComercial.carpinteriaInteriorOtros}',
							readOnly: false
						}
			 ]
		  }
		];

        me.callParent();
       	
       }
});