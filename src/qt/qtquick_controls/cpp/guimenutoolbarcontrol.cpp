#include "guimenutoolbarcontrol.h"

#include "guimenutoolbarlistview.h"
#include "qmlmenutoolbarmodel.h"
#include "qmlmenutoolbaritem.h"

#include "gui20_skin.h"

GUIMenuToolbarControl::GUIMenuToolbarControl( QQuickItem* a_pParent )
	: QQuickItem( a_pParent )
	, m_pMenuToolbarView( 0 )
	, m_strVisitWebsiteText( tr( "Visit our website" ) )
    , m_strWebsiteURL( tr( "www.sandcoins.com" ) )
{
}

GUIMenuToolbarControl::~GUIMenuToolbarControl()
{
	if ( m_pMenuToolbarView )
	{
		delete m_pMenuToolbarView;
		m_pMenuToolbarView = 0;
	}
}


void GUIMenuToolbarControl::initializeMenuToolbarView( GUIMenuToolbarListView* a_pView )
{
	if ( a_pView )
	{
		if ( m_pMenuToolbarView )
		{
			delete m_pMenuToolbarView;
		}
		m_pMenuToolbarView = a_pView;
		if ( m_pMenuToolbarView )
		{
			QmlMenuToolbarModel* pStandardMenuModel = new QmlMenuToolbarModel( m_pMenuToolbarView );
			if ( pStandardMenuModel )
			{
				pStandardMenuModel->append( new QmlMenuToolbarItem( tr( "Overview" ),			tr( "Overview description" ),			"qrc:/icons/res/icons/GUI20_mainToolBar_overview_hover.png",				"qrc:/icons/res/icons/GUI20_mainToolBar_overview.png"			, OVERVIEW		) );
				pStandardMenuModel->append( new QmlMenuToolbarItem( tr( "Send" ),				tr( "Send description" ),				"qrc:/icons/res/icons/GUI20_mainToolBar_send_hover.png",					"qrc:/icons/res/icons/GUI20_mainToolBar_send.png"				, SEND			) );
				pStandardMenuModel->append( new QmlMenuToolbarItem( tr( "Receive" ),			tr( "Receive description" ),			"qrc:/icons/res/icons/GUI20_mainToolBar_receive_hover.png",					"qrc:/icons/res/icons/GUI20_mainToolBar_receive.png"			, RECEIVE		) );
				pStandardMenuModel->append( new QmlMenuToolbarItem( tr( "Transactions" ),		tr( "Transactions description" ),		"qrc:/icons/res/icons/GUI20_mainToolBar_transactions_hover.png",			"qrc:/icons/res/icons/GUI20_mainToolBar_transactions.png"		, TRANSACTIONS	) );
				pStandardMenuModel->append( new QmlMenuToolbarItem( tr( "Contacts" ),			tr( "Contacts description" ),			"qrc:/icons/res/icons/GUI20_mainToolBar_contacts_hover.png",				"qrc:/icons/res/icons/GUI20_mainToolBar_contacts.png"			, CONTACTS		) );
				pStandardMenuModel->append( new QmlMenuToolbarItem( tr( "Redeem Prypto" ),		tr( "Redeem Prypto description" ),		"qrc:/icons/res/icons/GUI20_mainToolBar_redeemprypto_hover.png",			"qrc:/icons/res/icons/GUI20_mainToolBar_redeemprypto.png"		, REDEEM_PRYPTO	) );
				pStandardMenuModel->append( new QmlMenuToolbarItem( tr( "Info" ),				tr( "Info description" ),				"qrc:/icons/res/icons/GUI20_mainToolBar_info_hover.png",					"qrc:/icons/res/icons/GUI20_mainToolBar_info.png"				, INFO			) );
				pStandardMenuModel->SetCurrentItemIndex( 0 );
				m_pMenuToolbarView->SetModel( pStandardMenuModel );
                connectListViewSignals();
			}
		}
	}
}

void GUIMenuToolbarControl::setVisitWebsiteText( QString a_strNewText )
{
	if ( m_strVisitWebsiteText != a_strNewText )
	{
		m_strVisitWebsiteText = a_strNewText;
		emit signalVisitWebsiteTextChanged();
	}
}

void GUIMenuToolbarControl::setWebsiteURL( QString a_strNewText )
{
	if ( m_strWebsiteURL != a_strNewText )
	{
		m_strWebsiteURL = a_strNewText;
		emit signalWebsiteURLChanged();
	}
}

void GUIMenuToolbarControl::connectListViewSignals()
{
	if ( m_pMenuToolbarView )
	{
		disconnect( m_pMenuToolbarView );
		QmlMenuToolbarModel* pModel = m_pMenuToolbarView->GetModel();
		if ( pModel )
		{
			connect( pModel, SIGNAL( signalCurrentItemIndexChanged() ), this, SLOT( slotCurrentItemIndexChanged() ), Qt::UniqueConnection );
		}
	}
}

void GUIMenuToolbarControl::slotCurrentItemIndexChanged()
{
	emit signalCurrentItemIndexChanged();
}
