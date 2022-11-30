mvp = mvp or {}
mvp.utils = mvp.utils or {}
mvp.utils.cachedImages = mvp.utils.cachedImages or {}

function mvp.utils.DownloadImage(filename, url, callback, errorCallback, ignoreCache)
    filename = filename or 
        string.Split(url, '/')[#string.Split(url, '/')]

    local path = 'mvp/downloads/' .. filename
    local cache = mvp.utils.cachedImages[url]
    local dPath = 'data/' .. path

    if file.Exists(path, 'DATA') and not cache then -- initing cache value
        mvp.utils.cachedImages[url] = {path = dPath, material = Material(dPath)}

        return callback(unpack(mvp.utils.cachedImages[url]))
    end

    if cache and not ignoreCache then 
        return callback(unpack(mvp.utils.cachedImages[url]))
    end

    if (not file.IsDir(string.GetPathFromFilename(path), 'DATA')) then
        file.CreateDir(string.GetPathFromFilename(path))
    end

    errorCallback = errorCallback or function(reason)
        mvp.utils.Print(Format('Error occured when loading material from link %s, error:\n%s', url, reason))

        return 
    end

    http.Fetch(url, function(body, size, headers, code)
        if (code ~= 200) then return errorCallback(code) end
        file.Write(path, body)

        mvp.utils.cachedImages[url] = {path = dPath, material = Material(dPath)}

        callback(unpack(mvp.utils.cachedImages[url]))
    end, errorCallback)
end

local loadingMat = Material('mvp/loading.png')

function mvp.utils.DrawImage(url, x, y, w, h, pngParams)
    if not mvp.utils.cachedImages[url] then
        mvp.utils.DownloadImage('test')
    end
end