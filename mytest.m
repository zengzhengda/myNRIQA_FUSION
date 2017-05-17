function [iqa]=mytest(disimg)
feature=fetchFeature(disimg);
quality=get_quality(feature);
end