local THEME = mvp.themes.New()

THEME:SetName('MVP Default Light Theme')
THEME:SetAuthor('MVP')
THEME:SetDescription('Default library dark-theme')

THEME:SetVersion('1.0.0')

THEME:SetColor('primary', Color(224, 224, 224))
THEME:SetColor('primary_dark', Color(200, 200, 200))
THEME:SetColor('secondary', Color(231, 231, 231))
THEME:SetColor('secondary_dark', Color(236, 236, 236))
THEME:SetColor('accent', mvp.utils.HexToRGB('fbc531'))

THEME:SetColor('primary_text', Color(41, 41, 41))
THEME:SetColor('secondary_text', Color(41, 41, 41))
THEME:SetColor('accent_text', Color(71, 71, 71))

THEME:SetColor('icon', Color(255, 255, 255))
THEME:SetColor('icon_dark', Color(100, 100, 100))

THEME:SetColor('red', mvp.utils.HexToRGB('e84118'))
THEME:SetColor('green', mvp.utils.HexToRGB('4cd137'))
THEME:SetColor('blue', mvp.utils.HexToRGB('00a8ff')) 
THEME:SetColor('yellow', mvp.utils.HexToRGB('fbc531'))
THEME:SetColor('orange', mvp.utils.HexToRGB('ffa000'))
THEME:SetColor('purple', mvp.utils.HexToRGB('7e57c2')) 
THEME:SetColor('pink', mvp.utils.HexToRGB('e91e63'))
THEME:SetColor('brown', mvp.utils.HexToRGB('795548'))
THEME:SetColor('grey', mvp.utils.HexToRGB('9e9e9e'))
 
THEME:SetColor('white', mvp.utils.HexToRGB('ffffff'))
THEME:SetColor('black', mvp.utils.HexToRGB('000000'))

mvp.themes.Register(THEME)