hook.Add( 'HUDPaint', 'BlueScreen', function()

	if kill_blya == 1 then

		blue = Lerp(FrameTime()/0.3, blue, 0)
		draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 150, blue ) )

	end

end )