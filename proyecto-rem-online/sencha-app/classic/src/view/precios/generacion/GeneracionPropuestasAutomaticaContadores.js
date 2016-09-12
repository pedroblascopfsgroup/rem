Ext.define('HreRem.view.precios.generacion.GeneracionPropuestasAutomaticaContadores', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'generacionpropuestasautomaticacontadores',
    reference	: 'generacionPropuestasAutomaticaContadores',
    maxWidth: 600,
    bind: {
        store: '{numActivosByTipoPrecio}'
    },
	listeners: {
		cellclick : 'cellClickContadorAutomatico'
	},
	viewConfig : {
		disableSelection: true
	},
    initComponent: function () {
        
        var me = this;
        
        var carteraRenderer =  function(value) {
        	var src = 'logo_'+value.toLowerCase()+'.svg',
        	alt = value;
        	return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="100px"></div>';
        };
        
        me.columns= [
                     
                {
                	dataIndex: 'entidadPropietariaCodigo',
		            text: HreRem.i18n('header.precios.automatica.activos.cartera.codigo'),
		            flex: 1,
		            hidden: true
                },        
        		{
		            dataIndex: 'entidadPropietariaDescripcion',
		            //text: HreRem.i18n('header.entidad.propietaria'),
		            flex: 2,
		            cls: 'grid-no-seleccionable-primera-col',
					tdCls: 'grid-no-seleccionable-td',
		            renderer: carteraRenderer
		        },
		        {	        	
		            dataIndex: 'numActivosPreciar',
		            menuDisabled: true,
		            text: HreRem.i18n('header.precios.automatica.activos.preciar'),
		            flex: 1,
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            align: 'center'
		        },
		        {	        	
		            dataIndex: 'numActivosRepreciar',
		            menuDisabled: true,
		            text: HreRem.i18n('header.precios.automatica.activos.repreciar'),
		            flex: 1,
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            align: 'center'		        	
		        },
		        {	        	
		        	dataIndex: 'numActivosDescuento',
		            text: HreRem.i18n('header.precios.automatica.activos.descuento'),
		            flex: 1,
		            align: 'center',
		            hidden: true
		        }
        ];
        
        me.callParent(); 

        
    }


});

