Housing.Register('nolag_properties', {
    GetCurrentProperty = function()
        return LocalPlayer.state.propertyId -- currentProperty also covers yard zones
    end,
})
