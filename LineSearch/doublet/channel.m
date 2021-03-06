function channel(data_path, low, high, doublet_freqs, output_path, auto_filter_thresold)
	% search for a line in a channel at data_path
	% data_path: the path to the mat file
	% low: the low frequency
	% high: the high frequency
	% doublet_freqs: the frequency of the doublet
	% output_path: the output path down to the jpg image
	% auto_filter_thresold: automatic filter multiplier
	%  the filter gets the avg of the search range and the max within
	%  a 0.1Hz range. We only plot the channel when the latter is <thresold> times
	%  larger than the former. Set to 0, when not applied.

	freqs = [];
	coh = [];
	load(data_path);
	[~, channel_name, ~] = fileparts(data_path);
	freqGap = freqs(2) - freqs(1);
	il = floor(low / freqGap) + 1;
	ih = ceil(high / freqGap) + 1;
	if il > length(coh)
		disp(strcat(data_path, ' out of range. Skipped.'));		
		return
    	elseif ih > length(coh)
        	disp(strcat(data_path, ' range chopped.'));
		ih = length(coh);
    	end
	fp = freqs(il : ih);
	cp = coh(il : ih);
	if (auto_filter_thresold ~= 0)
		all_avg = mean(cp);
		fl = floor((doublet_freqs(1) - 0.05) / freqGap) + 1;
        	fh = ceil((doublet_freqs(1) + 0.05) / freqGap) + 1;
		fh = min(fh, ih);
		fcp = coh(fl : fh);
		filt_max = max(fcp);
		if (filt_max >= all_avg * auto_filter_thresold)
			output(channel_name, fp, cp, doublet_freqs, output_path);
		else
			fl = floor((doublet_freqs(2) - 0.05) / freqGap) + 1;
                	fh = ceil((doublet_freqs(2) + 0.05) / freqGap) + 1;
                	fh = min(fh, ih);
        	        fcp = coh(fl : fh);
	                filt_max = max(fcp);
			if (filt_max >= all_avg * auto_filter_thresold)
                        	output(channel_name, fp, cp, doublet_freqs, output_path);
		end
	end
end
