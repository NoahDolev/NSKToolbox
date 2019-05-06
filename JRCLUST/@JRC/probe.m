function probe(obj, probeFile)
    %PROBE Plot a probe layout
    if nargin > 1
        [~, ~, ext] = fileparts(probeFile);
        if isempty(ext) % a convenience for a forgetful mind
            probeFile = [probeFile '.prb'];
        end

        probeFile_ = jrclust.utils.absPath(probeFile, fullfile(jrclust.utils.basedir(), 'probes'));
        if isempty(probeFile_)
            obj.errMsg = sprintf('Could not find probe file: %s', probeFile);
            obj.isError = 1;
            return;
        end

        showProbe(jrclust.Config(struct('probe_file', probeFile)));
    elseif isempty(obj.hCfg) 
        obj.errMsg = 'Specify a probe file or config file';
        obj.isError = 1;
        return;
    else
        showProbe(obj.hCfg);
    end
end

%% LOCAL FUNCTIONS
function showProbe(probeData)
    %DOPLOTPROBE Plot a figure representing a probe
    hFigProbe = jrclust.views.Figure('FigProbe', [0 0 .5 1], 'Probe', 0, 0);

    vrX = [0 0 1 1] * probeData.probePad(2);
    vrY = [0 1 1 0] * probeData.probePad(1);

    XData = bsxfun(@plus, probeData.siteLoc(:, 1)', vrX(:));
    YData = bsxfun(@plus, probeData.siteLoc(:, 2)', vrY(:));
    nSites = size(probeData.siteLoc, 1);

    % plot sites
    hFigProbe.addPlot('hPatch', @patch, XData, YData, 'w', 'EdgeColor', 'k');

    % label sites
    if ~isempty(probeData.siteMap)
        siteLabels = arrayfun(@(i)sprintf('%d/%d', i, probeData.siteMap(i)), 1:numel(probeData.siteMap), 'UniformOutput', 0);
    else
        siteLabels = arrayfun(@(i) sprintf('%d', i), 1:nSites, 'UniformOutput', 0);
    end
    hFigProbe.addPlot('hText', @text, probeData.siteLoc(:,1), probeData.siteLoc(:,2), siteLabels, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');

    hFigProbe.axApply('default', @axis, [min(XData(:)), max(XData(:)), min(YData(:)), max(YData(:))]);
    hFigProbe.axApply('default', @title, 'Site# / Chan# (zoom: wheel; pan: hold wheel & drag)');
    hFigProbe.axApply('default', @xlabel, 'X Position (\mum)');
    hFigProbe.axApply('default', @ylabel, 'Y Position (\mum)');
    hFigProbe.axApply('default', @axis, 'equal');

    hFigProbe.setMouseable();
end