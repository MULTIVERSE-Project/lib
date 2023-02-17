local THEME = mvp.themes.New()

THEME:SetName('MVP Dark Red Theme')
THEME:SetAuthor('MVP')
THEME:SetDescription('Default library dark-themed look')

THEME:SetVersion('1.0.0')

THEME:SetColor('primary', mvp.utils.HexToRGB('212121'))
THEME:SetColor('primary_dark', mvp.utils.HexToRGB('252525'))
THEME:SetColor('secondary', mvp.utils.HexToRGB('353535'))
THEME:SetColor('secondary_dark', mvp.utils.HexToRGB('303030'))
THEME:SetColor('accent', mvp.utils.HexToRGB('e84118'))

THEME:SetColor('primary_text', mvp.utils.HexToRGB('f5f6fa'))
THEME:SetColor('secondary_text', mvp.utils.HexToRGB('dcdde1'))
THEME:SetColor('accent_text', mvp.utils.HexToRGB('e84118'))

THEME:SetColor('icon', mvp.utils.HexToRGB('ffffff'))

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