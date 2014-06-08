reqbuildermenu = {}
reqbuildermenu.msgnotext = 'No text selected.'
reqbuildermenu.warnedualimit = false

function reqbuildermenu:run(func)
 local sel = reqbuilder.edit.getsel()
 if sel ~= '' then
  reqbuilder.edit.replacesel(func(sel))
 else
  app.showmessage(reqbuildermenu.msgnotext)
 end
end

function reqbuildermenu:spliturl()
 local text = reqbuilder.edit.gettext()
 if text ~= '' then
  text = slx.string.replace(text,'?','?'..string.char(10))
  text = slx.string.replace(text,'&',string.char(10)..'&')
  reqbuilder.edit.settext(text)
 end
end

function reqbuildermenu:getmethod()
 local method = 'GET'
 if reqbuilder.request.postdata ~= '' then
  method = 'POST'
 end
 return method
end

function reqbuildermenu:getrequestparams()
 return {
  url = reqbuilder.request.url,
  method = self:getmethod(),
  postdata = reqbuilder.request.postdata,
  headers = reqbuilder.request.headers,
  usecookies = reqbuilder.request.usecookies,
  usecredentials = reqbuilder.request.usecredentials,
  ignorecache = reqbuilder.request.ignorecache,
  details = 'Browser Request (Manual)'
 }
end

function reqbuildermenu:sendrequest()
 browser.options.showheaders = true
 if reqbuilder.request.url ~= '' then
  tab:sendrequest(self:getrequestparams())
 end
 reqbuilder.edit.setfocus()
end

function reqbuildermenu:loadrequest()
 if Sandcat:IsURLLoaded(true) == true then
 browser.options.showheaders = true
 if reqbuilder.request.agent ~= '' then
  if self.warnedualimit == false then
   app.showmessage('User agent spoofing not supported for loading requests.')
   self.warnedualimit = true
  end
 end
  if reqbuilder.request.url ~= '' then
   tab:loadrequest(self:getrequestparams())
  end
 end
 reqbuilder.edit.setfocus()
end