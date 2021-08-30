//
//  RemoteFeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Vitaly Shpinyov on 29.08.2021.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

final class RemoteFeedImageMapper {
	private struct Root: Decodable {
		let items: [RemoteFeedImage]
		var feed: [FeedImage] {
			return items.map { $0.image }
		}
	}

	private struct RemoteFeedImage: Decodable {
		let image_id: UUID
		let image_desc: String?
		let image_loc: String?
		let image_url: URL

		var image: FeedImage {
			return FeedImage(id: image_id,
			                 description: image_desc,
			                 location: image_loc,
			                 url: image_url)
		}
	}

	private static var OK_200: Int { return 200 }

	private init() {}

	static func map(_ data: Data, from response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == OK_200,
		      let root = try? JSONDecoder().decode(Root.self, from: data)
		else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}
		return .success(root.feed)
	}
}
