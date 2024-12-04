var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = ReversedSeries","category":"page"},{"location":"#ReversedSeries","page":"Home","title":"ReversedSeries","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for ReversedSeries.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [ReversedSeries]","category":"page"},{"location":"#ReversedSeries.Reversed","page":"Home","title":"ReversedSeries.Reversed","text":"struct Reversed{T<:AbstractArray}\n\nA::AbstractArray\n\nThis presents a reversed view of anything array-like.\n\nCredit: @simsurace\n\nExample\n\njulia> a = [1, 2, 3]\njulia> r = Reversed(a)\njulia> r[1]\n3\njulia> r[3]\n1\njulia> a[end] == r[1]\ntrue\n\n\n\n\n\n","category":"type"},{"location":"#ReversedSeries.ReversedFrame","page":"Home","title":"ReversedSeries.ReversedFrame","text":"struct ReversedFrame{df<:DataFrames.DataFrame}\n\ndf::DataFrames.DataFrame\ns::Dict\n\nThis presents a reversed view of an entire DataFrame.\n\nExample\n\njulia> rf = ReversedFrame(btcusd) # btcusd is a DataFrame\njulia> rf[:ts][1] # the most recent timestamp\njulia> rf[:ts][2] # the timestamp before that\njulia> rf[:c][1] # the close at 1 corresponds with the timestamp at 1\njulia> rf[:o][1] == btcusd.o[end]\ntrue\n\nIndex 1 is the origin and represents the present time.\nHigher indices go back in time.\nThis is similar to how series are indexed in TradingView's PineScript except they use a 0-based index.\n\n\n\n\n\n","category":"type"},{"location":"#Base.getindex-Tuple{ReversedFrame, Symbol}","page":"Home","title":"Base.getindex","text":"getindex(rf::ReversedFrame, k::Symbol) -> Any\n\n\nReturn a reversed view of a DataFrame column via indexing.\n\n\n\n\n\n","category":"method"},{"location":"#Base.getproperty-Tuple{ReversedFrame, Symbol}","page":"Home","title":"Base.getproperty","text":"getproperty(rf::ReversedFrame, k::Symbol) -> Any\n\n\nReturn a reversed view of a DataFrame column via key.\n\n\n\n\n\n","category":"method"},{"location":"#ReversedSeries.crossed_down-Tuple{Any, Any}","page":"Home","title":"ReversedSeries.crossed_down","text":"crossed_down(a, b; i) -> Any\n\n\nDid series a become less than series b at index i.\n\n\n\n\n\n","category":"method"},{"location":"#ReversedSeries.crossed_down_now-Tuple{Any, Any}","page":"Home","title":"ReversedSeries.crossed_down_now","text":"crossed_down_now(a, b; i) -> Any\n\n\nIs series a currently less than series b?\n\n\n\n\n\n","category":"method"},{"location":"#ReversedSeries.crossed_up-Tuple{Any, Any}","page":"Home","title":"ReversedSeries.crossed_up","text":"crossed_up(a, b; i) -> Any\n\n\nDid series a become greater than series b at index i.\n\n\n\n\n\n","category":"method"},{"location":"#ReversedSeries.crossed_up_now-Tuple{Any, Any}","page":"Home","title":"ReversedSeries.crossed_up_now","text":"crossed_up_now(a, b; i) -> Any\n\n\nIs series a currently greater than series b?\n\n\n\n\n\n","category":"method"},{"location":"#ReversedSeries.hidden_bearish-Tuple{}","page":"Home","title":"ReversedSeries.hidden_bearish","text":"hidden_bearish()\n\n\n\n\n\n\n","category":"method"},{"location":"#ReversedSeries.hidden_bullish-Tuple{}","page":"Home","title":"ReversedSeries.hidden_bullish","text":"hidden_bullish()\n\n\n\n\n\n\n","category":"method"},{"location":"#ReversedSeries.regular_bearish-Tuple{}","page":"Home","title":"ReversedSeries.regular_bearish","text":"regular_bearish()\n\n\n\n\n\n\n","category":"method"},{"location":"#ReversedSeries.regular_bullish-Tuple{}","page":"Home","title":"ReversedSeries.regular_bullish","text":"regular_bullish()\n\n\n\n\n\n\n","category":"method"}]
}
