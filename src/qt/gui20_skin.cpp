#include "gui20_skin.h"


GUI20Skin::GUI20Skin( QObject* a_pParent )
	: QObject( a_pParent )
//	, colorToolbarMainGradientBegin( "#9c181c" )
    , colorToolbarMainGradientBegin( "#22b7e6" )
//    , colorToolbarMainGradientEnd( "#a61b22" )
    , colorToolbarMainGradientEnd( "#25c9fc" )
//	, colorToolbarMainCurrent( "#761316" )
    , colorToolbarMainCurrent( "#1d9dc4" )
//	, colorToolbarMainBottomCurrent( "#e1252b" )
    , colorToolbarMainBottomCurrent( "#59d8ff" )
	, colorToolbarMainTextCurrent( "#ffffff" )
//	, colorToolbarMainTextNormal( "#3f0a0c" )
    , colorToolbarMainTextNormal( "#002040" )
	, colorToolbarMainTextWebsiteURL( colorToolbarMainTextCurrent )
    , colorToolbarMainTextVisitWebsite( "#002040" )
//	, colorToolbarMainTextShadow( "#c72427" )
    , colorToolbarMainTextShadow( "#3fcffc" )
	, colorWindowBackground( "#f0f0f0" )
	, colorFrameBackground( "#ffffff" )
	, colorButtonTopGradient( colorFrameBackground )
	, colorButtonBottomGradient( "#F2F2F2" )
	, colorButtonMid( "#F8F8F8" )
	, colorButtonDark( colorButtonBottomGradient )
	, colorButtonLight( colorFrameBackground )
//	, colorListCurrent( "#F5E5E5" )
    , colorListCurrent( "#E5F0F5" )
	, colorListValue( colorFrameBackground )
//	, colorListValueAlternative( "#F5F5F5" )
    , colorListValueAlternative( "#E5F5F5" )
	, colorTextActive( "#404040" )
	, colorTextActiveAutocomplete( "#6B3D3D" )
	, colorTextDisabled( "#707070" )
	, colorTextDisabledAutocomplete( "#8B5D5D" )
    , colorTextBlack("#000000")
{
}

GUI20Skin& GUI20Skin::Instance()
{
	static GUI20Skin	m_oInstance;
	return m_oInstance;
}

GUI20Skin::~GUI20Skin()
{

}

