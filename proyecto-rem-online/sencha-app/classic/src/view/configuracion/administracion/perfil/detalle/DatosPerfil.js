Ext.define('HreRem.view.configuracion.administracion.perfiles.detalle.DatosPerfil', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosperfil',
    reference: 'datosPerfil',
    cls	: 'panel-base shadow-panel',    
    scrollable	: 'y',
    recordName: "perfil",
	recordClass: "HreRem.model.FichaPerfilModel",
    requires: ['HreRem.model.FichaPerfilModel'],

	
	initComponent: function() {
		var me = this;
    	me.setTitle(HreRem.i18n('title.configuracion.perfiles.perfiles'));
    	me.items= [
            { 
            	xtype: 'textfieldbase',
            	fieldLabel: HreRem.i18n('fieldlabel.configuracion.perfiles.descripcion'),
            	bind: '{perfil.perfilDescripcion}',
            	readOnly: true
            },				                
            { 
            	xtype: 'textfieldbase',
				fieldLabel: HreRem.i18n('fieldlabel.configuracion.perfiles.descripcionLarga'),
				bind: '{perfil.perfilDescripcionLarga}',
				maxLength: 250
            }
       ];
	   	
	    me.callParent();
	}
});