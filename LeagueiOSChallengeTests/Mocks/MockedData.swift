//
//  MockedData.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 08/12/2025.
//

import XCTest
@testable import LeagueiOSChallenge

final class MockedData {
    static let mockedGeo: Geo = Geo(
        lat: "123.123",
        lng: "123.123"
    )

    static let mockedAddress: Address = Address(
        street: "Fake Street 123",
        suite: "Apt. 556",
        city: "Gwenborough",
        zipcode: "92998-3874",
        geo: MockedData.mockedGeo
    )

    static let mockedCompany: Company = Company(
        name: "Company",
        catchPhrase: "Company Phrase",
        bs: "bs"
    )

    static let mockedUser: UserResponse = UserResponse(
        id: 1,
        avatar: "https://via.placeholder.com/150",
        name: "User",
        username: "username",
        email: "someemail@gmail.com",
        address: MockedData.mockedAddress,
        phone: "012131231321",
        website: "www.company.com",
        company: MockedData.mockedCompany
    )
    
    static let posts: [PostsResponse] = [
        .init(userId: 1, id: 1, title: "Post 1", body: "Body 1"),
        .init(userId: 1, id: 2, title: "Post 2", body: "Body 2"),
        .init(userId: 2, id: 3, title: "Post 3", body: "Body 3"),
        .init(userId: 3, id: 4, title: "Post 4", body: "Body 4")
    ]
    
    static let users: [UserResponse] = [
        .init(id: 1, avatar: "", name: "name 1", username: "user_1", email: "email_1@gmail.com", address: MockedData.mockedAddress, phone: "phone_1", website: "website_1", company: MockedData.mockedCompany),
        .init(id: 2, avatar: "", name: "name 2", username: "user_2", email: "email_2@gmail.com", address: MockedData.mockedAddress, phone: "phone_2", website: "website_2", company: MockedData.mockedCompany),
        .init(id: 3, avatar: "", name: "name 3", username: "user_3", email: "email_3@gmail.com", address: MockedData.mockedAddress, phone: "phone_3", website: "website_3", company: MockedData.mockedCompany)
    ]

}
