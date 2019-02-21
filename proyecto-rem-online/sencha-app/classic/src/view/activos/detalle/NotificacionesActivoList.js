Ext.define('HreRem.view.activos.detalle.NotificacionesActivoList', {
	extend: 'HreRem.view.common.GridBase',
    xtype: 'notificacionesactivolist',
    
    bind: {
        store: '{storeNotificacionesActivo}'
    },
    topBar:  false,
    removeButton: false,
    
    estaComunicado: false,
    addButton:  false,
    hideButton : function(me) {

    	var parent = me.up().up().up();
    	var estado = parent.form.findField('estadoComunicacion');
    	if (estado) { 
    		estado = estado.value;
    	}
    	var hide = estado === CONST.ESTADO_COMUNICACION_GENCAT['COMUNICADO'] ? false : true;
    	if (me.down('toolbar')) {
    		me.down('toolbar').setHidden(hide);
    	}
    	
    },
        
    initComponent: function () {
        
        var me = this; 
        
        me.columns= [
		        {
		            dataIndex: 'fechaNotificacion',
		            text: HreRem.i18n('fieldlabel.fecha.notificacion'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'nombre',
		            text: HreRem.i18n('header.nombre.documento'),
		            flex: 1
		        },
		        {
		            dataIndex: 'motivoNotificacion',
		            text: HreRem.i18n('fieldlabel.motivo'),
		            flex: 2
		        },
		        {
		            dataIndex: 'fechaSancionNotificacion',
		            text: HreRem.i18n('fieldlabel.fecha.sancion.notificacion'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'cierreNotificacion',
		            text: HreRem.i18n('fieldlabel.cierre.notificacion'),
		            formatter: 'date("d/m/Y")',
		            flex: 2
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'reclamacionesactivolistPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeNotificacionesActivo}'
		            }
		        }
		];
        
        me.tbar =  {
    			xtype: 'toolbar',
    			dock: 'top',
    			hidden: true,
    			items: [
    					{itemId: 'addButton', iconCls:'x-fa fa-plus', handler: 'onAddClick', hidden: false, scope: this}
    			]
		};
        
        me.callParent();
        setTimeout(function(){me.hideButton(me)}, 4000);
        
    },
    onAddClick: function(btn) {
    	var me = this;
    	me.lookupController().abrirFormularioCrearNotificacion(me);
    }


});