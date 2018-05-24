//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation
import Common

public class DomainRegistry: AbstractRegistry {

    public static var walletRepository: WalletRepository {
        return service(for: WalletRepository.self)
    }

    public static var portfolioRepository: SinglePortfolioRepository {
        return service(for: SinglePortfolioRepository.self)
    }

    public static var accountRepository: AccountRepository {
        return service(for: AccountRepository.self)
    }

    public static var blockchainService: BlockchainDomainService {
        return service(for: BlockchainDomainService.self)
    }

}
