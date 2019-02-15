Ext.define('HreRem.view.activos.detalle.PropuestaActivosVinculadosList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'propuestaActivosVinculadosList',
	topBar: true,
	idPrincipal : 'activo.id',
	editOnSelect: false,
	
    bind: {
        store: '{storePropuestaActivosVinculados}'
    },
    
    listeners: {
    	boxready: function() {
    		var me = this;
    		me.evaluarEdicion();
    	}
    },
    
    initComponent: function () {
     	
     	var me = this;
		
		me.columns = [
				{
					xtype: 'actioncolumn',
					handler: 'onActivosVinculadosClick',
					items: [{
			            tooltip: 'Ver Activo',
			            iconCls: 'app-list-ico ico-ver-activov2'
			        }],
				    flex     : 0.2,            
				    align: 'center',
				    menuDisabled: true,
				    hideable: false
				},
				{
					dataIndex: 'id',
					text: HreRem.i18n('header.publicacion.activos.vinculados.id'),
					align: 'center',
					flex: 0.3,
					hidden: true
				},
				{
					dataIndex: 'activoVinculadoID',
					text: HreRem.i18n('header.publicacion.activos.vinculados.idActivo'),
					align: 'center',
					flex: 0.3,
					hidden: true
				},
		        {
		            dataIndex: 'activoVinculadoNumero',
		            text: HreRem.i18n('fieldlabel.propuesta.activos.vinculados'),
		            flex: 1,
		            align: 'center',
		            editor: {
		       			xtype:'textfield'
		       		}
		        }
		    ];

	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'activosPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true,
	            bind: {
	                store: '{storePropuestaActivosVinculados}'
	            }
	        }
	    ];

	    me.callParent();
   },
   
   //HREOS-846 Si NO esta dentro del perimetro, ocultamos del grid las opciones de agregar/elminar
   evaluarEdicion: function() {    	
		var me = this;
		
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false" || me.lookupController().getViewModel().get('activo').get('isActivoEnTramite')) {
			me.setTopBar(false);
		}
   }
});