Ext.define('HreRem.view.activos.detalle.HistoricoEstadosList', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'historicoestadoslist',
	topBar		: false,
	allowDeselect: true,
	allowBlank	: true,
	idPrincipal : 'activo.id',
	
    bind: {
        store: '{historicoEstados}'
    },
    
    initComponent: function () {
     	
     	var me = this;
		
	    
		me.columns = [
		        {
		        	dataIndex: 'id',
		        	text: HreRem.i18n('title.publicaciones.condiciones.id'),
		        	flex:0.5,
		        	hidden:true
		        },
		        {
		        	
		            dataIndex: 'idActivo',
		            text: HreRem.i18n('title.publicaciones.condiciones.idactivo'),
		            flex: 0.5,
		            hidden: true
		        },
		        {
		            dataIndex: 'fechaDesde',
		            text: HreRem.i18n('title.publicaciones.condiciones.fechadesde'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaHasta',
		            text: HreRem.i18n('title.publicaciones.condiciones.fechahasta'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'portal',
		            text: HreRem.i18n('title.publicaciones.historico.portal'),
		            flex: 1
		        },
		        {
		            dataIndex: 'tipoPublicacion',
		            text: HreRem.i18n('title.publicaciones.historico.tipopublicacion'),
		            flex: 1
		        },
		        {
		            dataIndex: 'motivo',
		            text: HreRem.i18n('title.publicaciones.estados.motivo'),
		            flex: 2
		        },
		        {
		        	dataIndex: 'usuario',
		            text: HreRem.i18n('fieldlabel.usuario'),
		            flex: 1
		        },
		        {
		            dataIndex: 'estadoPublicacion',
		            text: HreRem.i18n('title.publicaciones.historico.estado'),
		            flex: 1
		        },
		        {
		            dataIndex: 'diasPeriodo',
		            text: HreRem.i18n('title.publicaciones.historico.diasperiodo'),
		            flex: 1
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
		                store: '{historicoEstados}'
		            }
		        }
		    ];
		    
		    
		    me.callParent();
   },
   
   onGridBaseSelectionChange: function(grid, records) {
	   //Se sobreescribe para que no deje eliminar.
   }

});