aphone.Stencils = aphone.Stencils or {}
local stencil_writemask = render.SetStencilWriteMask
local stencil_testmask = render.SetStencilTestMask
local stencil_id = render.SetStencilReferenceValue
local stencil_fail = render.SetStencilFailOperation
local stencil_zfail = render.SetStencilZFailOperation
local stencil_compare = render.SetStencilCompareFunction
local stencil_pass = render.SetStencilPassOperation

function aphone.Stencils.Start()
    -- Reset
    stencil_writemask(0xFF)
    stencil_testmask(0xFF)
    stencil_fail(STENCIL_KEEP)
    stencil_zfail(STENCIL_KEEP)
    stencil_id(1)
    -- Stencil
    stencil_compare(STENCIL_EQUAL)
    stencil_pass(STENCIL_INCRSAT)
end

function aphone.Stencils.AfterMask(ext)
    stencil_id(2)
    stencil_pass(STENCIL_DECRSAT)
    stencil_compare(ext and STENCIL_LESS or STENCIL_EQUAL)
end

function aphone.Stencils.End()
    stencil_id(1)
    stencil_pass(STENCIL_REPLACE)
end