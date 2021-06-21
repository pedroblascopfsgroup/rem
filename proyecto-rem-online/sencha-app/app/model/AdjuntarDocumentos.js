/**
 * This view is used to present the details of a single AgendaItem.
 
Ext.define('HreRem.model.AdjuntarDocumentos, {
			extend : 'HreRem.model.Base',
			idProperty : 'id',
			fields : [
					{
						name : 'entidad'
					},
					{
						name : 'idEntidad'
					},
					{
						name : 'parent'
					}

			],
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'admision/getTabDataRevisionTitulo',
				api : {
					read : 'admision/getTabDataRevisionTitulo',
					create : 'admision/saveTabDataRevisionTitulo',
					update : 'admision/saveTabDataRevisionTitulo'
				}
			}
		});
*/